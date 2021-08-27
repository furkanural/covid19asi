defmodule VaccineTracker.Vaccines.Vaccine do
  use Ecto.Schema

  schema "vaccines" do
    field :total, :integer
    field :total_dose_one, :integer
    field :total_dose_two, :integer
    field :total_dose_three, :integer
    field :today, :integer
    field :today_dose_one, :integer
    field :today_dose_two, :integer
    field :today_dose_three, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(vaccine, params \\ %{}) do
    vaccine
    |> Ecto.Changeset.cast(params, [:total, :total_dose_one, :total_dose_two, :total_dose_three, :today, :today_dose_one, :today_dose_two, :today_dose_three])
    |> Ecto.Changeset.validate_required([:total, :total_dose_one, :total_dose_two, :total_dose_three, :today, :today_dose_one, :today_dose_two, :today_dose_three])
  end
end
