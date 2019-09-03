#include <stdio.h>
#include <vips/vips.h>

double log2(double x) {
  return log(x) * 1.4426950408889634;
}


#if __GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ > 4)
# define MY_PROXY_LIBINTL_GNUC_FORMAT(arg_idx) __attribute__((__format_arg__(arg_idx)))
#else
# define MY_PROXY_LIBINTL_GNUC_FORMAT(arg_idx)
#endif

#define G_INTL_EXPORT extern

#define BUHU { return "LIBINTL TODO"; }


G_INTL_EXPORT char *g_libintl_gettext (const char *msgid) MY_PROXY_LIBINTL_GNUC_FORMAT (1) BUHU

G_INTL_EXPORT char *g_libintl_dgettext (const char *domainname,
                                 const char *msgid) MY_PROXY_LIBINTL_GNUC_FORMAT (2) BUHU

G_INTL_EXPORT char *g_libintl_dcgettext (const char *domainname,
                        const char *msgid,
                        int         category) MY_PROXY_LIBINTL_GNUC_FORMAT (2) BUHU

G_INTL_EXPORT char *g_libintl_ngettext (const char       *msgid1,
                                 const char       *msgid2,
                                 unsigned long int n) MY_PROXY_LIBINTL_GNUC_FORMAT (1) MY_PROXY_LIBINTL_GNUC_FORMAT (2) BUHU

G_INTL_EXPORT char *g_libintl_dngettext (const char       *domainname,
                                  const char       *msgid1,
                                  const char       *msgid2,
                                  unsigned long int n) MY_PROXY_LIBINTL_GNUC_FORMAT (2) MY_PROXY_LIBINTL_GNUC_FORMAT (3) BUHU

G_INTL_EXPORT char *g_libintl_dcngettext (const char       *domainname,
                                   const char       *msgid1,
                                   const char       *msgid2,
                                   unsigned long int n,
                                   int               category) MY_PROXY_LIBINTL_GNUC_FORMAT (2) MY_PROXY_LIBINTL_GNUC_FORMAT (3) BUHU

G_INTL_EXPORT char *g_libintl_textdomain (const char *domainname) BUHU

G_INTL_EXPORT char *g_libintl_bindtextdomain (const char *domainname,
                                       const char *dirname) BUHU

G_INTL_EXPORT char *g_libintl_bind_textdomain_codeset (const char *domainname,
                                                const char *codeset) BUHU

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
