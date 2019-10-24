qr_process <- function(drive_id, sheet_id) {

  fn <- paste0(drive_id, ".jpg")
  #name, local_path, id, drive_resource
  meta_drive <- drive_download(
    file = as_dribble(as_id(drive_id)),
    path = fn,
    overwrite = T
  )

  img <- image_read(fn) %>%
    image_crop("2000x2000")

  meta_exif <- image_attributes(img) %>%
    filter(property == "exif:DateTime")

  meta_file <- tibble(
    orig_file = meta_drive$name,
    file_link = drive_link(meta_drive),
    image_taken = meta_exif$value
  )

  # values (id, [type], value); points (id, x, y)
  meta_qr <- qr_scan(img)$values[c("id", "value")]

  if (nrow(meta_qr) == 0) {

    meta_qr <- meta_qr %>% add_row(id = 0)

    new_row <- bind_cols(meta_file, meta_qr) %>%
      mutate_all(~stringr::str_replace_na(., ""))

    message(crayon::style("\nThere was a read error, appending partial row to DB.", "yellow1"))

  } else {

    site <- stringr::str_extract(meta_qr$value, "[A-Z]{3}")
    message(crayon::style(glue::glue("\n\nSuccessful read of image from site: {site}."), "green1"))

    new_row <- bind_cols(meta_file, meta_qr)

  }

  # filename, file link, time taken, id, value
  gs_add_row(
    sheet_id,
    ws = "Reads",
    input = new_row
  )

  invisible(file.remove(fn))
  print(new_row, width = Inf)
}


