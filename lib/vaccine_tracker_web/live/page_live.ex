defmodule VaccineTrackerWeb.PageLive do
  use VaccineTrackerWeb, :live_view

  alias VaccineTracker.Vaccines, as: Vaccines

  @impl true
  def mount(_params, _session, socket) do

    {:ok, assign(socket, vaccines: [],  vaccine: Vaccines.get_last())}
  end

  @impl true
  def handle_event("show_past_days", _, socket) do
    socket = assign(socket, vaccines: Vaccines.all())
    {:noreply, socket}
  end

  @impl true
  def handle_event("hide_past_days", _, socket) do
    socket = assign(socket, vaccines: [])
    {:noreply, socket}
  end

  def format_datetime(date) do
    Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

    DateTime.shift_zone!(date, "Europe/Istanbul") |> DateTime.to_naive |> NaiveDateTime.to_string
  end

  def format_date(date) do
    Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

    date |> DateTime.shift_zone!("Europe/Istanbul") |> DateTime.to_date() |> Date.to_iso8601()
  end

  defp format_number_string(string, join \\ " ", delimer \\ ".") do
    string
    |> String.split(delimer)
    |> List.first
    |> String.split("")
    |> List.delete_at(-1)
    |> Enum.reverse
    |> Enum.chunk_every(3, 3, [])
    |> Enum.map(&(Enum.reverse(&1) |> Enum.join))
    |> Enum.reverse
    |> Enum.join(join)
  end

  def format_number(number) when is_float(number), do: number |> Float.to_string |> format_number_string
  def format_number(number) when is_integer(number), do: number |> Integer.to_string |> format_number_string
  def format_number(number, join) when is_float(number), do: number |> Float.to_string |> format_number_string(join)
  def format_number(number, join) when is_integer(number), do: number |> Integer.to_string |> format_number_string(join)
  def format_number(number, join, delimer) when is_float(number), do: number |> Float.to_string |> format_number_string(join, delimer)
  def format_number(number, join, delimer) when is_integer(number), do: number |> Integer.to_string |> format_number_string(join, delimer)
end
