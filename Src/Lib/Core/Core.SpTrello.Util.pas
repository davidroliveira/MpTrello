unit Core.SpTrello.Util;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, REST.Client,
  REST.Response.Adapter;

type
  TTFDMemTableHelper = class helper for TFDMemTable
    procedure DataInJson(const Value: TRESTResponse; const AOpen: Boolean = True);
  end;

implementation

{ TTFDMemTableHelper }

procedure TTFDMemTableHelper.DataInJson(const Value: TRESTResponse;
  const AOpen: Boolean = True);
var
  oRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
begin
  Self.Close;
  if Value.content <> '[]' then
  begin
    oRESTResponseDataSetAdapter := TRESTResponseDataSetAdapter.Create(nil);
    try
      oRESTResponseDataSetAdapter.Dataset := Self;
      oRESTResponseDataSetAdapter.Response := Value;
      if AOpen then
        Self.Open;
    finally
      FreeAndNil(oRESTResponseDataSetAdapter);
    end;
  end;
end;

end.

