defmodule VaccineTracker.Repo.Migrations.CreateVaccines do
  use Ecto.Migration

  def change do
    create table(:vaccines) do
      add :total, :integer
      add :total_dose_one, :integer
      add :total_dose_two, :integer
      add :today, :integer
      add :today_dose_one, :integer
      add :today_dose_two, :integer

      timestamps()
    end
  end
end
