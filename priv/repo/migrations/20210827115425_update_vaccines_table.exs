defmodule VaccineTracker.Repo.Migrations.UpdateVaccinesTable do
  use Ecto.Migration

  def change do
    alter table(:vaccines) do
      add :total_dose_three, :integer, default: 0
      add :today_dose_three, :integer, default: 0
    end
  end
end
