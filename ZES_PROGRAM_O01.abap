*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_O01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  IF go_picture1 IS INITIAL.
    CREATE OBJECT: go_container1 EXPORTING container_name = 'PICTURE',
                   go_picture1   EXPORTING parent = go_container1.
  ENDIF.

  CALL METHOD go_picture1->load_picture_from_url
    EXPORTING
      url    = gs_graphic_url
    EXCEPTIONS
      OTHERS = 4.

  SET PF-STATUS 'STATUS_100'.
  SET TITLEBAR 'TITLEBAR_100'.

ENDMODULE.