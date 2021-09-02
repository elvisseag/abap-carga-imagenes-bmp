*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_MAI
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  CHECK p_direct IS NOT INITIAL.

  PERFORM get_files.
  PERFORM process.
  IF gtd_result[] IS NOT INITIAL.
    PERFORM alv_display_result.
  ENDIF.

*  imagename = p_image.
*  perform show_status using 'Importing Image from Front End'.
*  PERFORM import_bitmap USING p_file imagename 'Material Imagen'.

