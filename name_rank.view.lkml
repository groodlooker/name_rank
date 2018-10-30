view: name_rank {
    derived_table: {
      datagroup_trigger: names_pred_group
      explore_source: names {
        column: number {}
        column: name {}
        column: year {}
        column: state {}
        column: gender {}
        derived_column: rank_gender_year {
          sql: RANK() OVER(PARTITION BY year, gender, state ORDER BY number desc) ;;
        }
      }
    }
    dimension: number {
      type: number
    }
    dimension: name {}
    dimension: year {
      type: number
    }
    dimension: state {}
    dimension: gender {}
    dimension: rank_gender_year {
      type: number
    }
  }

  explore: name_rank {}# If necessary, uncomment the line below to include explore_source.
# include: "name_rank.view.lkml"

view: rank_py {
  derived_table: {
    datagroup_trigger: names_pred_group
    explore_source: name_rank {
      column: name {}
      column: year {}
      column: state {}
      column: number {}
      column: rank_gender_year {}
      column: gender {}
      derived_column: rank_gender_py{
        sql: LAG(rank_gender_year,1) OVER(PARTITION BY name, state, gender ORDER BY year asc) ;;
      }
      derived_column: rank_gender_2y {
        sql: LAG(rank_gender_year,2) OVER(PARTITION BY name, state, gender ORDER BY year asc) ;;
      }
      derived_column: rank_gender_3y {
        sql: LAG(rank_gender_year,3) OVER(PARTITION BY name, state, gender ORDER BY year asc) ;;
      }
      derived_column: rank_gender_4y {
        sql: LAG(rank_gender_year,4) OVER(PARTITION BY name, state, gender ORDER BY year asc) ;;
      }
      derived_column: rank_gender_5y {
        sql: LAG(rank_gender_year,5) OVER(PARTITION BY name, state, gender ORDER BY year asc) ;;
      }
      derived_column: min_rank {
        sql: MAX(rank_gender_year) OVER(PARTITION BY name, gender, year) ;;
      }
      derived_column: max_rank {
        sql: MIN(rank_gender_year) OVER(PARTITION BY name, gender, year) ;;
      }
    }
  }
  dimension: name {}
  dimension: year {
    type: number
  }
  dimension: state {}
  dimension: number {
    type: number
  }
  dimension: rank_gender_year {
    type: number
  }
  dimension: gender {}
  dimension: rank_gender_py {
    type: number
  }
  dimension: rank_gender_2y {
    type: number
  }
  dimension: rank_gender_3y {
    type: number
  }
  dimension: rank_gender_4y {
    type: number
  }
  dimension: rank_gender_5y {
    type: number
  }
  dimension: min_rank {
    type: number
  }
  dimension: max_rank {
    type: number
  }
  measure: rank_gender_year_m {
    type: max
    sql: ${rank_gender_year} ;;
  }
  measure: rank_gender_py_m {
    type: max
    sql: ${rank_gender_py} ;;
  }
}

explore: rank_py {}

# If necessary, uncomment the line below to include explore_source.
# include: "name_rank.view.lkml"

# view: rolling_ranks {
#   derived_table: {
#     explore_source: rank_py {
#       column: name {}
#       column: state {}
#       column: year {}
#       column: gender {}
#       column: rank_gender_year {}
#       column: rank_gender_py {}
#       column: max_rank {}
#       column: min_rank {}
#       derived_column: five_year_max {
#         sql: (
#              select MAX(rank_gender_py)
#              from rank_py r
#              where rank_py.name = r.name
#              and rank_py.gender = r.gender
#              and rank_py.state = r.state
#              and rank_py.year >= r.year - 5) ;;
#       }
#     }
#   }
#   dimension: name {}
#   dimension: state {}
#   dimension: year {
#     type: number
#   }
#   dimension: rank_gender_year {
#     type: number
#   }
#   dimension: rank_gender_py {}
#   dimension: max_rank {}
#   dimension: min_rank {}
# }
#
# explore: rolling_ranks {}

