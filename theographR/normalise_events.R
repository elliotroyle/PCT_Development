#' This script normalises event data to a standard schema
#'
#' Returns columns:
#'   entity_id, entity_name, date (Date), term, value, units, note
#'
#' @param df A data.frame/tibble.
#' @param mappings Named list mapping your columns to the schema:
#'   entity_id, entity_name, date, term, value, units, note
#' @param parse_date Either "ymd"|"dmy"|"mdy" or a function(x) -> Date
#' @return tibble with the standard columns
normalise_events <- function(
    df,
    mappings = list(
      entity_id   = "PK_Patient_ID",
      entity_name = "Patient_Name",
      date        = "Contact_Event_Date",
      term        = "Contact_Event_Term",
      value       = "Value",
      units       = "Units",
      note        = "Prescription_Instruction"
    ),
    parse_date = "ymd"
) {
  stopifnot(is.data.frame(df))
  need <- c("entity_id","entity_name","date","term","value","units","note")
  missing_map <- setdiff(need, names(mappings))
  if (length(missing_map)) {
    stop("`mappings` must include: ", paste(missing_map, collapse=", "))
  }
  
  # check columns exist in df
  src <- unname(unlist(mappings[need]))
  miss_cols <- setdiff(src, names(df))
  if (length(miss_cols)) {
    stop("Input data is missing expected columns: ", paste(miss_cols, collapse=", "))
  }
  
  # build output
  out <- dplyr::transmute(
    df,
    entity_id   = .data[[mappings$entity_id]],
    entity_name = .data[[mappings$entity_name]],
    date        = .data[[mappings$date]],
    term        = .data[[mappings$term]],
    value       = .data[[mappings$value]],
    units       = .data[[mappings$units]],
    note        = .data[[mappings$note]]
  )
  
  # parse date
  if (is.character(parse_date)) {
    if      (parse_date == "ymd") out$date <- lubridate::ymd(out$date)
    else if (parse_date == "dmy") out$date <- lubridate::dmy(out$date)
    else if (parse_date == "mdy") out$date <- lubridate::mdy(out$date)
    else stop("Unknown parse_date keyword. Use 'ymd','dmy','mdy' or a function.")
  } else if (is.function(parse_date)) {
    out$date <- parse_date(out$date)
  } else {
    stop("`parse_date` must be a keyword or a function.")
  }
  
  dplyr::arrange(out, .data$entity_name, .data$date)
}
