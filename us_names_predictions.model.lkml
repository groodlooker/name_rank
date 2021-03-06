connection: "us_names"

# include all the views
include: "*.view"

datagroup: names_pred_group {
  sql_trigger: SELECT MAX(id) FROM names;;
  max_cache_age: "1 hour"
}

persist_with: names_pred_group

explore: names {}
# changes to save
