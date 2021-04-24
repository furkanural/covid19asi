defmodule VaccineTrackerWorker.CrawlerWorker do

  alias VaccineTracker.Vaccines, as: Vaccines

  def perform do
    {:ok, document} = html_document()

    attr = Floki.find(document, "script") |> attr()

    case Vaccines.get_last() do
      nil ->
        Vaccines.create_vaccine(attr)
      vaccine ->
        update_or_create_vaccine(vaccine, attr)
    end
  end

  def update_or_create_vaccine(vaccine, attr) do
    case is_same_day(vaccine.inserted_at, NaiveDateTime.local_now()) do
      true ->
        updated_attr =
          attr
          |> Map.update!(:today, fn _ ->
            attr.total - vaccine.total + vaccine.today
          end)
          |> Map.update!(:today_dose_one, fn _ ->
            attr.total_dose_one - vaccine.total_dose_one + vaccine.today_dose_one
          end)
          |> Map.update!(:today_dose_two, fn _ ->
            attr.total_dose_two - vaccine.total_dose_two + vaccine.today_dose_two
          end)

        Vaccines.update_vaccine(vaccine, updated_attr)
      false ->
        attr
        |> Map.update!(:today, fn _ ->
          attr.total - vaccine.total
        end)
        |> Map.update!(:today_dose_one, fn _ ->
          attr.total_dose_one - vaccine.total_dose_one
        end)
        |> Map.update!(:today_dose_two, fn _ ->
          attr.total_dose_two - vaccine.total_dose_two
        end)
        |> Vaccines.create_vaccine
    end
  end

  defp is_same_day(t1, t2) when t1.year == t2.year and t1.day == t2.day and t1.month == t2.month, do: true
  defp is_same_day(_t1, _t2), do: false

  defp attr(scripts) do
    %{
      total: find_in_scripts(scripts, "yapilanasisayisi") |> String.to_integer(),
      total_dose_one: find_in_scripts(scripts, "asiyapilankisisayisi1Doz") |> String.to_integer(),
      total_dose_two: find_in_scripts(scripts, "asiyapilankisisayisi2Doz") |> String.to_integer(),
      today: 0,
      today_dose_one: 0,
      today_dose_two: 0
    }
  end

  defp html_document do
    %{body: body} = HTTPoison.get!('https://covid19asi.saglik.gov.tr')

    Floki.parse_document(body)
  end

  defp find_in_scripts([], _), do: ""
  defp find_in_scripts([script | scripts], text) do
    with 3 <- tuple_size(script),
        {:ok, number} <- find_in_tuple(elem(script, 2), text)
    do
      number
    else _ ->
      find_in_scripts(scripts, text)
    end
  end

  defp find_in_tuple([el], text) do
    case Regex.match?(~r/var #{text} = ([0-9]*);/, el) do
      true ->
        {:ok, Regex.scan(~r/var #{text} = ([0-9]*);/, el) |> List.first() |> List.last()}
      _ ->
        {:empty}
    end
  end
end
