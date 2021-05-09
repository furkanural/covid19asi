defmodule VaccineTracker.Vaccines do
  import Ecto.Query, warn: false
  alias VaccineTracker.Repo

  alias VaccineTracker.Vaccines.Vaccine

  def get_last do
    Vaccine
    |> Ecto.Query.first([desc: :updated_at])
    |> Repo.one
  end

  def all do
    Vaccine
    |> Ecto.Query.order_by(desc: :inserted_at)
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
  end
end
