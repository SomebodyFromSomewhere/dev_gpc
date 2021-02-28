{/////////////////////////////////////////////}
{/// include file for Win32 API sources  /////}
{/////////////////////////////////////////////}
{$ifndef Windows_Inc}
  {$define Windows_Inc}
  {$undef IS_UNIT}
  {$undef WINDOWS_UNIT}
  {$i messages.pas}
  {$i wintypes.pas}
  {$i winprocs.pas}
{$endif Windows_Inc}

