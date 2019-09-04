#include <stdio.h>
#include <vips/vips.h>

#include "missing_symbols_fix.c"

int main(int argc, char **argv) {
  VipsImage *in;
  VipsImage *out;
  float w;
  float h;

  if (VIPS_INIT(argv[0]))
    vips_error_exit(NULL);

  if (argc != 3)
    vips_error_exit("usage: %s infile outfile", argv[0]);

  if (!(in = vips_image_new_from_file(argv[1], NULL)))
    vips_error_exit(NULL);

  w = (float)vips_image_get_width(in);
  h = (float)vips_image_get_height(in);
  printf("image width = %d\n", vips_image_get_width(in));

  // vips_autorot()
  // autorotates based on exif tag :)

  if (vips_extract_area(in, &out, (int)(0.25 * w), (int)(0.25 * h),
                        (int)(0.5 * w), (int)(0.5 * h), NULL))
    vips_error_exit(NULL);

  if (vips_resize(out, &out, 9.5, NULL))
    vips_error_exit(NULL);

  g_object_unref(in);

  if (vips_image_write_to_file(out, argv[2], NULL))
    vips_error_exit(NULL);

  g_object_unref(out);

  return (0);
}
