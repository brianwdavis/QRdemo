# Explicit decoding ----

readable <-
  system.file("extdata/DSC_0002.jpg", package = "QRdemo") %>%
  image_read() %>%
  image_resize("25%")
readable

qr_scan(readable, plot = T)


unreadable <-
  system.file("extdata/DSC_0003.jpg", package = "QRdemo") %>%
  image_read()
unreadable

qr_scan(unreadable)



# Initialize DB ----
# folder_id <- readLines("secret.txt")
# sheet_id <- qr_sheet_init(folder_id)

# Where is the DB? ----
sheet_id

# What images are there? ----
image_ids <- qr_list(folder_id)
image_ids

# Read the images, store in the DB ----
decoded <- map(image_ids, ~qr_process(.x, sheet_id))
do.call("rbind", decoded)

# Clean up and start over ----
gs_key(sheet_id$sheet_key) %>% qr_sheet_reset()



