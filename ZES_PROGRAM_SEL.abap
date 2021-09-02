*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_SEL
*&---------------------------------------------------------------------*


SELECTION-SCREEN: FUNCTION KEY 1.

SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE text-t01.
*PARAMETERS: p_file TYPE localfile DEFAULT 'C:file.bmp'.
PARAMETERS: p_direct TYPE localfile DEFAULT ''.
*PARAMETERS: p_image TYPE stxbitmaps-tdname.
SELECTION-SCREEN: END OF BLOCK b01.



INITIALIZATION.
  " Botón agregar manualmente
  gwa_dyntxt-text        = 'Visualizar imágenes'.
  gwa_dyntxt-icon_id     = '@3W@'.
  gwa_dyntxt-quickinfo   = 'Visualizar imágenes'.
  gwa_dyntxt-icon_text   = 'Visualizar imágenes'.
  sscrfields-functxt_01  = gwa_dyntxt.

AT SELECTION-SCREEN.
  "IF sscrfields-ucomm = 'FC01'.
  IF sy-ucomm = 'FC01'.
    PERFORM lista_imagenes.
  ENDIF.


*DATA: imagename TYPE stxbitmaps-tdname.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
*    EXPORTING
*      static    = 'X'
*    CHANGING
*      file_name = p_file.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_direct.
  CALL FUNCTION 'TMP_GUI_BROWSE_FOR_FOLDER'
    EXPORTING
      window_title    = 'Elija un directorio'
*     INITIAL_FOLDER  =
    IMPORTING
      selected_folder = p_direct
    EXCEPTIONS
      cntl_error      = 1
      OTHERS          = 2.
  IF sy-subrc EQ 0.
  ENDIF.