*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_FILES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_files .

  gs_dir_name = p_direct.

  CALL FUNCTION 'TMP_GUI_DIRECTORY_LIST_FILES'
    EXPORTING
      directory  = gs_dir_name
      filter     = '*.bmp'
* IMPORTING
*     FILE_COUNT =
*     DIR_COUNT  =
    TABLES
      file_table = gtd_file_list
      dir_table  = gtd_dir_list
    EXCEPTIONS
      cntl_error = 1
      OTHERS     = 2.
  IF sy-subrc EQ 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process .

  DATA: ls_matnr_r TYPE mara-matnr,
        ls_matnr_f TYPE mara-matnr,
        ls_part1   TYPE string,
        ls_part2   TYPE string,
        ls_part3   TYPE string.

  CLEAR: gtd_result[].

  LOOP AT gtd_file_list INTO gwa_file_list.

    CLEAR: gwa_result, ls_part1, ls_part2, ls_part3, ls_matnr_r, ls_matnr_f.

    CONCATENATE p_direct '\' gwa_file_list-pathname INTO gs_full_name.
    gs_imagename = gwa_file_list-pathname.

    TRANSLATE gs_imagename TO UPPER CASE.
    REPLACE '.BMP' WITH '' INTO gs_imagename.
    CONCATENATE 'ZM_' gs_imagename INTO gs_imagename.
    gs_file = gs_full_name.
    gwa_result-imagen = gs_imagename.

    SPLIT gs_imagename AT '_' INTO ls_part1 ls_part2 ls_part3.
    CONDENSE ls_part2.
    ls_matnr_f = ls_part2.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_matnr_f
      IMPORTING
        output = ls_matnr_f.

    SELECT SINGLE matnr INTO ls_matnr_r
      FROM mara
      WHERE matnr EQ ls_matnr_f.
    IF sy-subrc EQ 0.

      PERFORM import_bitmap USING gs_file gs_imagename 'Material Imagen'.
      IF sy-subrc EQ 0.
        COMMIT WORK.
        gwa_result-mensaje = 'La imagen se cargó correctamente'.
      ELSE.
        gwa_result-mensaje = 'La imagen NO se cargó correctamente'.
      ENDIF.

    ELSE.
      gwa_result-mensaje = 'El material no existe'.
    ENDIF.

    APPEND gwa_result TO gtd_result.

  ENDLOOP.

ENDFORM.



************************************************************************
*       FORM import_Bitmap                                             *
************************************************************************
FORM import_bitmap USING filename
                         name
                         title.

  DATA: l_resolution TYPE stxbitmaps-resolution,
        l_docid      TYPE stxbitmaps-docid.

  l_docid = 200.
  PERFORM import_bitmap_bds
                  IN PROGRAM saplstxbitmaps
                            USING    filename
                                     name
                                     'GRAPHICS'     "Object
                                     'BMAP'         "ID
                                     'BCOL'         "B/W
                                     'BMP'          "Extension
                                     title
                                     space
                                     'X'
                                     'X'
                            CHANGING l_docid
                                     l_resolution.

ENDFORM.

FORM alv_display_result.

  CLEAR: gtd_fieldcat[].

* Add to Fieldcat
  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'IMAGEN'.    "Field name
  gwa_fieldcat-seltext_m = 'Imagen'. "Medium description
  gwa_fieldcat-seltext_s = 'Img.'.     "Short description
  gwa_fieldcat-outputlen = '30'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'MENSAJE'.
  gwa_fieldcat-seltext_m = 'Mensaje'.
  gwa_fieldcat-seltext_s = 'Msj.'.
  gwa_fieldcat-outputlen = '50'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

* Display ALV
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = gtd_fieldcat[]
      i_grid_title  = 'Resultado de la carga'
    TABLES
      t_outtab      = gtd_result[]
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

ENDFORM.


FORM alv_display_zm_images.

  CLEAR: gtd_fieldcat[].

* Add to Fieldcat
  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'NAME'.    "Field name
  gwa_fieldcat-seltext_m = 'Nombre'. "Medium description
  gwa_fieldcat-seltext_s = 'Nombre'.     "Short description
  gwa_fieldcat-outputlen = '20'.
  gwa_fieldcat-hotspot   = 'X'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'OBJECT'.
  gwa_fieldcat-seltext_m = 'Objeto'.
  gwa_fieldcat-seltext_s = 'Objeto'.
  gwa_fieldcat-outputlen = '10'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'ID'.
  gwa_fieldcat-seltext_m = 'ID'.
  gwa_fieldcat-seltext_s = 'ID'.
  gwa_fieldcat-outputlen = '5'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'TYPEDESC'.
  gwa_fieldcat-seltext_m = 'Tp.gráfico'.
  gwa_fieldcat-seltext_s = 'Tp.gráfico'.
  gwa_fieldcat-outputlen = '30'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'DESC'.
  gwa_fieldcat-seltext_m = 'Signif.'.
  gwa_fieldcat-seltext_s = 'Signif.'.
  gwa_fieldcat-outputlen = '64'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'USERC'.
  gwa_fieldcat-seltext_m = 'Creado por'.
  gwa_fieldcat-seltext_s = 'Creado por'.
  gwa_fieldcat-outputlen = '20'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'USERM'.
  gwa_fieldcat-seltext_m = 'Modif.por'.
  gwa_fieldcat-seltext_s = 'Modif.por'.
  gwa_fieldcat-outputlen = '20'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

*  CLEAR: gwa_fieldcat.
*  gwa_fieldcat-fieldname = 'LINK'.
*  gwa_fieldcat-seltext_m = 'Imágen'.
*  gwa_fieldcat-seltext_s = 'Imágen'.
*  gwa_fieldcat-outputlen = '8'.
*  gwa_fieldcat-hotspot   = 'X'.
*  gwa_fieldcat-just      = 'C'.
*  APPEND gwa_fieldcat TO gtd_fieldcat.

* Display ALV
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      it_fieldcat             = gtd_fieldcat[]
      i_grid_title            = 'Imágenes de materiales cargadas'
    TABLES
      t_outtab                = gtd_imagenes[]
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

ENDFORM.

FORM user_command USING r_ucomm     TYPE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  IF rs_selfield-fieldname EQ 'NAME'.

    READ TABLE gtd_imagenes INTO gwa_imagenes INDEX rs_selfield-tabindex.
    IF sy-subrc EQ 0.
      PERFORM ver_imagen USING gwa_imagenes-name.
    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data.

  CLEAR: gtd_stxbitmaps[].
  SELECT * INTO TABLE gtd_stxbitmaps
    FROM stxbitmaps
    WHERE tdobject EQ 'GRAPHICS'
      AND tdname   LIKE 'ZM_%'
      AND tdid     EQ 'BMAP'
      AND tdbtype  EQ 'BCOL'.

  CLEAR: gtd_imagenes[].
  LOOP AT gtd_stxbitmaps INTO gwa_stxbitmaps.

    CLEAR: gwa_bds_properties.

    CALL FUNCTION 'SAPSCRIPT_ATTRIB_GRAPHIC_BDS'
      EXPORTING
        i_object        = gwa_stxbitmaps-tdobject
        i_name          = gwa_stxbitmaps-tdname
        i_id            = gwa_stxbitmaps-tdid
        i_btype         = gwa_stxbitmaps-tdbtype
        read_only       = 'X'
      IMPORTING
        e_fuser         = gwa_bds_properties-fuser
        e_fdate         = gwa_bds_properties-fdate
        e_ftime         = gwa_bds_properties-ftime
        e_luser         = gwa_bds_properties-luser
        e_ldate         = gwa_bds_properties-ldate
        e_ltime         = gwa_bds_properties-ltime
        e_description   = gwa_bds_properties-description
*       e_resolution    = g_stxbitmaps-resolution
*       e_resident      = g_stxbitmaps-resident
*       e_autoheight    = g_stxbitmaps-autoheight
*       e_widthtw       = g_stxbitmaps-widthtw
*       e_heighttw      = g_stxbitmaps-heighttw
*       e_widthpix      = g_stxbitmaps-widthpix
*       e_heightpix     = g_stxbitmaps-heightpix
*       e_compressed    = g_stxbitmaps-bmcomp
      EXCEPTIONS
        bds_info_failed = 1
        not_found       = 2
        OTHERS          = 3.

    IF sy-subrc EQ 0.
      CLEAR: gwa_imagenes.
      gwa_imagenes-name   = gwa_stxbitmaps-tdname.
      gwa_imagenes-object = gwa_stxbitmaps-tdobject.
      gwa_imagenes-id     = gwa_stxbitmaps-tdid.
*      gwa_imagenes-type   = gwa_stxbitmaps-tdbtype.
      IF gwa_stxbitmaps-tdbtype EQ 'BCOL'.
        gwa_imagenes-typedesc = 'Im.gráf.tramas en color'.
      ELSEIF gwa_stxbitmaps-tdbtype EQ 'BMON'.
        gwa_imagenes-typedesc = 'Im.gráf.tramas blanco/negro'.
      ENDIF.
      gwa_imagenes-desc   = gwa_bds_properties-description.
      gwa_imagenes-userc  = gwa_bds_properties-fuser.
      gwa_imagenes-userm  = gwa_bds_properties-luser.
*      gwa_imagenes-link   = '@10@'.
      APPEND gwa_imagenes TO gtd_imagenes.
    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LISTA_IMAGENES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM lista_imagenes .

  PERFORM get_data.
  IF gtd_imagenes[] IS NOT INITIAL.
    PERFORM alv_display_zm_images.
  ENDIF.

ENDFORM.


FORM ver_imagen USING p_nombre.

  DATA: lx_graphic_xstr TYPE xstring,
        li_graphic_conv TYPE i,
        li_graphic_offs TYPE i.

  CLEAR: gs_graphic_url, gtd_graphic_table[].

  gwa_stxbitmaps-tdobject = 'GRAPHICS'.
  gwa_stxbitmaps-tdname   = p_nombre.
  gwa_stxbitmaps-tdid     = 'BMAP'.
  gwa_stxbitmaps-tdbtype  = 'BCOL'.

  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object  = gwa_stxbitmaps-tdobject
      p_name    = gwa_stxbitmaps-tdname
      p_id      = gwa_stxbitmaps-tdid
      p_btype   = gwa_stxbitmaps-tdbtype
    RECEIVING
      p_bmp     = lx_graphic_xstr
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
  IF sy-subrc = 0.
  ENDIF.

  gi_graphic_size = xstrlen( lx_graphic_xstr ).
  CHECK gi_graphic_size > 0.

  li_graphic_conv = gi_graphic_size.
  li_graphic_offs = 0.

  WHILE li_graphic_conv > 255.
    CLEAR: gwa_graphic_table.
    gwa_graphic_table-line = lx_graphic_xstr+li_graphic_offs(255).
    APPEND gwa_graphic_table TO gtd_graphic_table.
    li_graphic_offs = li_graphic_offs + 255.
    li_graphic_conv = li_graphic_conv - 255.
  ENDWHILE.

  CLEAR: gwa_graphic_table.
  gwa_graphic_table-line = lx_graphic_xstr+li_graphic_offs(li_graphic_conv).
  APPEND gwa_graphic_table TO gtd_graphic_table.

  CALL FUNCTION 'DP_CREATE_URL'
    EXPORTING
      type                 = 'IMAGE'                "#EC NOTEXT
      subtype              = 'BMP' "cndp_sap_tab_unknown " 'X-UNKNOWN'
*     size                 = gi_graphic_size
*     lifetime             = cndp_lifetime_transaction  " 'T'
    TABLES
      data                 = gtd_graphic_table
    CHANGING
      url                  = gs_graphic_url
    EXCEPTIONS
      dp_invalid_parameter = 1
      dp_error_put_table   = 2
      dp_error_general     = 3
      OTHERS               = 4.
  IF sy-subrc EQ 0.
    CALL SCREEN 100 STARTING AT 3 10.
  ENDIF.

ENDFORM.