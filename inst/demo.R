# Initialize ----
# folder_id <- readLines("secret.txt")
# sheet_id <- qr_sheet_init(folder_id)

# Where is the DB? ----
sheet_id

# What images are there? ----
image_ids <- qr_list(folder_id)
image_ids

# Read the images, store in the DB ----
map(image_ids, ~qr_process(.x, sheet_id))

# Clean up and start over ----
qr_sheet_reset(sheet_id)


# Explicit decoding ----

readable <-
  system.file("extdata/W BNF B2 T2.jpg", package = "QRdemo") %>%
  image_read() %>%
  image_resize("25%")
readable

qr_scan(readable, plot = T)


unreadable <-
  system.file("extdata/W ETO C1 T1.jpg", package = "QRdemo") %>%
  image_read()
unreadable

qr_scan(unreadable)


