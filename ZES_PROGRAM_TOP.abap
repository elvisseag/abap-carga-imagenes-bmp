*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS slis.
TABLES: sscrfields.

TYPES:

  BEGIN OF gty_graphic_table,
    line(255) TYPE x,
  END OF gty_graphic_table,

  begin of gty_bds_properties,
     fuser            like rsscg-bds_fuser,
     fdate            like rsscg-fdate,
     ftime            like rsscg-ftime,
     luser            like rsscg-bds_luser,
     ldate            like rsscg-ldate,
     ltime            like rsscg-ltime,
     description      like rsscg-bds_title,
   end of gty_bds_properties,

  BEGIN OF gty_result,
    imagen(50)  TYPE c,
    mensaje(60) TYPE c,
  END OF gty_result,

  BEGIN OF gty_imagenes,
    name   TYPE stxbitmaps-tdname,
    object TYPE stxbitmaps-tdobject,
    id     TYPE stxbitmaps-tdid,
    typedesc TYPE c LENGTH 30, "stxbitmaps-tdbtype,
    desc   TYPE rsscg-bds_title,
    userc  TYPE rsscg-bds_fuser,
    userm  TYPE rsscg-bds_luser,
*    link   TYPE icon_d,
  END OF gty_imagenes.

DATA: gtd_graphic_table   TYPE STANDARD TABLE OF gty_graphic_table,
      gwa_graphic_table   TYPE gty_graphic_table,
      gi_graphic_size     TYPE i,
      gs_graphic_url(256) TYPE c.

DATA: gtd_stxbitmaps     TYPE STANDARD TABLE OF stxbitmaps,
      gwa_stxbitmaps     TYPE stxbitmaps,
      gwa_bds_properties TYPE gty_bds_properties.

DATA: gtd_result   TYPE STANDARD TABLE OF gty_result,
      gtd_imagenes TYPE STANDARD TABLE OF gty_imagenes,
      gwa_result   TYPE gty_result,
      gwa_imagenes TYPE gty_imagenes.

DATA: gwa_dyntxt TYPE smp_dyntxt.

DATA: gtd_fieldcat TYPE slis_t_fieldcat_alv,
      gwa_fieldcat TYPE slis_fieldcat_alv.

DATA: gs_file       TYPE localfile,
      gs_imagename  TYPE stxbitmaps-tdname,
      gs_dir_name   TYPE pfeflnamel,
      gtd_file_list TYPE TABLE OF sdokpath,
      gtd_dir_list  TYPE TABLE OF sdokpath,
      gwa_file_list LIKE LINE OF gtd_file_list,
      gs_full_name  TYPE string.

DATA: go_container1 TYPE REF TO cl_gui_custom_container,
      go_picture1   TYPE REF TO cl_gui_picture.