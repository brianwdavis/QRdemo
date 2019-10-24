# not working
# qr_drive_init <- function() {
#   new_folder <- drive_mkdir("QR_demo")
#
#   system.file("extdata", package = "QRdemo") %>%
#     list.files(full.names = T) %>%
#     map(~drive_upload(.x, path = new_folder))
#
#   return(new_folder)
# }


qr_sheet_init <- function(folder_id) {
  sheet_id <-
    gs_new(
      title = "QR Demo DB",
      ws_title = "Reads",
      row_extent = 10,
      col_extent = 5
    ) %>%
    qr_sheet_reset()

  drive_mv(
    as_dribble(as_id(sheet_id$sheet_key)),
    path = as_dribble(as_id(folder_id))
    )

  return(sheet_id)
}

qr_sheet_reset <- function(sheet_id) {

  heading <- tibble(
    Filename = "(on Drive)",
    Link = "(click for preview)",
    `Time Taken` = "(from EXIF)",
    `Success?` = "(0 or 1)",
    value = "(encoded text)"
  )

  gs_edit_cells(
    sheet_id,
    "Reads",
    input = heading,
    col_names = T,
    byrow = T,
    trim = T
  )
}

qr_list <- function(folder_id) {
  all_files <- drive_ls(as_dribble(as_id(folder_id)))

  image_indices <- all_files$drive_resource %>% map_lgl(~.x$mimeType == "image/jpeg")
  all_files$id[image_indices]
}

# not working because folder isn't working
# qr_cleanup <- function(folder_id, sheet_id) {
#   drive_rm(folder_id)
#   gs_delete(sheet_id)
# }
