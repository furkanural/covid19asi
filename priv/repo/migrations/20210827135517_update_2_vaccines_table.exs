defmodule VaccineTracker.Repo.Migrations.Update2VaccinesTable do
  use Ecto.Migration

  def change do
    alter table(:vaccines) do
      remove :total_dose_three
      remove :today_dose_three
    end
  end
end
