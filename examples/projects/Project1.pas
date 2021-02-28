PROGRAM Project1;

USES
Unit1,
Unit2,
Windows, cClasses, cWindows, cDialogs;

{$X+}           {* use extended syntax, etc *}
{#apptype gui}  {* build a Win32 GUI application *}


Const ProjectName = 'Project1';

{* the main window object *}
TYPE
pNewWindow = ^TNewWindow; {* we are using a TWindow descendant *}
TNewWindow = OBJECT ( TWindow )
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE  SetupWindow; VIRTUAL;
   FUNCTION   ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
END;

{* the application object *}
TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
END;


{* implementations of the new object methods *}
CONSTRUCTOR TNewWindow.Init;
BEGIN
  Inherited Init ( Owner, aTitle );
  Attr.X := 1;
  Attr.Y := 1;
  Attr.W := 450;
  Attr.H := 350;
END;

{* Here is where to customize the main window *}
PROCEDURE TNewWindow.SetupWindow;
VAR
 i : hMenu;
 sMenu : TMenu;
BEGIN
   Inherited SetupWindow;
   SetCaption ( ProjectName );   {* anoother example of setting the window caption *}

   { Init a template for a typical SDI application }
   WITH sMenu DO BEGIN
       Init ( SelfPtr );
       i := AddSubMenu ( '&File  ', 0 );
         AddMenuItem ( i, '&New', CM_FileNew, 0 );
         AddMenuItem ( i, '&Open ...', CM_FileOpen, 0 );
         AddMenuItem ( i, '&Save', CM_FileSave, 0 );
         AddMenuItem ( i, 'Save &As ...', CM_FileSaveAs, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, '&Print ...', CM_FilePrint, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, 'E&xit', CM_FileExit, 0 );
       i := AddSubMenu ( '&Edit  ', 0 );
         AddMenuItem ( i, '&Undo', CM_EditUndo, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, 'Cu&t', CM_EditCut, 0 );
         AddMenuItem ( i, '&Copy', CM_EditCopy, 0 );
         AddMenuItem ( i, '&Paste', CM_EditPaste, 0 );
         AddMenuItem ( i, 'De&lete', CM_EditDelete, 0 );
       i := AddSubMenu ( '&Search  ', 0 );
         AddMenuItem ( i, '&Find ...', CM_SearchFind, 0 );
         AddMenuItem ( i, 'Find &Next', CM_SearchFindNext, 0 );
         AddMenuItem ( i, '&Replace ...', CM_SearchReplace, 0 );
       i := AddSubMenu ( '&Help  ', 0 );
         AddMenuItem ( i, '&Help Topics ', CM_HelpTopics, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, '&About', CM_HelpAbout, 0 );
   END;
END;

{* this is where menu selections are processed *}
FUNCTION TNewWindow.ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;
BEGIN
  Result := 0;
  CASE ID OF {* ID is the identifier of the menu selection *}
      CM_FileExit : WMClose ( Msg );
      CM_HelpAbout : ShowMessage ( 'Skeleton ObjectMingw Application' );
  ELSE
   Result := Inherited ProcessCommands ( Msg, Id );
  END;
END;


{* instantiate the main application window *}
PROCEDURE TNewApplication.InitMainWindow;
BEGIN
   MainWindow := New ( pNewWindow, Init ( Nil, ProjectName ) );
END;

VAR
MyApp : TNewApplication;
BEGIN
 WITH MyApp DO BEGIN
     Init ( ProjectName );
     Run;
     Done;
  END;
END.

