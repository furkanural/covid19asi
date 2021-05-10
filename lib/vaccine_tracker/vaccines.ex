defmodule VaccineTracker.Vaccines do
  import Ecto.Query, warn: false
  alias VaccineTracker.Repo

  alias VaccineTracker.Vaccines.Vaccine

  @vaccine inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(VaccineTracker.PubSub, @vaccine)
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(VaccineTracker.PubSub, @vaccine, {__MODULE__, event, result})

    {:ok, result}
  end

  def get_last do
    Vaccine
    |> Ecto.Query.first([desc: :updated_at])
    |> Repo.one
  end

  def all do
    Vaccine
    |> Ecto.Query.order_by(desc: :inserted_at)
    |> Ecto.Query.offset(1)
    |> Repo.all
  end

  @spec create_vaccine(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  def create_vaccine(attrs \\ %{}) do
    %Vaccine{}
    |> Vaccine.changeset(attrs)
    |> Repo.insert()
  end

  def update_vaccine(vaccine = %Vaccine{}, attrs \\ %{}) do
    vaccine
    |> Vaccine.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:vaccine, :updated])
  end
end
