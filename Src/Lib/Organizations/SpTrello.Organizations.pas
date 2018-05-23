unit SpTrello.Organizations;

interface

uses
  System.SysUtils, System.Classes, SpTrello.Authenticator,
  FireDAC.Comp.Client, Data.DB;

type
  TSpTrelloOrganizations = class
  private
    FSpAuthenticator: TSpTrelloAuthenticator;
    FDataSet: TFDMemTable;
    FActive: Boolean;
    procedure SetSpAuthenticator(const Value: TSpTrelloAuthenticator);
    procedure SetDataSet(const Value: TFDMemTable);
    procedure SetActive(const Value: Boolean);
  public
    procedure Refresh;
    function Delete: Boolean; overload;
    function Delete(const sId: string): Boolean; overload;
    function Insert(const sName, sDisplayName, sDesc, sWebSite: string): Boolean;
    function Edit(const sId, sFieldName, sValue: string): Boolean; overload;
    function Edit(sFieldName, sValue: string): Boolean; overload;
  published
    property SpTrelloAuthenticator: TSpTrelloAuthenticator read FSpAuthenticator write SetSpAuthenticator;
    property DataSet: TFDMemTable read FDataSet write SetDataSet;
    property Active: Boolean read FActive write SetActive default False;
  end;

implementation

uses System.Threading, Core.SpTrello.Util, REST.Client, Core.SpTrello.Organizations;

resourcestring
  StrComponentAuthentica = 'Component Authenticator não encontrado.';

{ TSpTrelloOrganizations }

function TSpTrelloOrganizations.Delete: Boolean;
begin
  Result := FDataSet <> nil;
  if Result then
    Result := Self.Delete(FDataSet.FieldByName('id').AsString);
end;

function TSpTrelloOrganizations.Delete(const sId: string): Boolean;
begin
  with TCoreSpTrelloOrganizations.Create(FSpAuthenticator) do
  begin
    try
      Result := Delete(sId).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TSpTrelloOrganizations.Edit(sFieldName, sValue: string): Boolean;
begin
  Result := FDataSet <> nil;
  if Result then
    Result := Self.Edit(FDataSet.FieldByName('id').AsString, sFieldName, sValue);
end;

function TSpTrelloOrganizations.Edit(const sId, sFieldName,
  sValue: string): Boolean;
begin
  if FSpAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  with TCoreSpTrelloOrganizations.Create(FSpAuthenticator) do
  begin
    try
      Result := Put(sId, sFieldName, sValue).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TSpTrelloOrganizations.Insert(const sName, sDisplayName, sDesc,
  sWebSite: string): Boolean;
begin
  if FSpAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  with TCoreSpTrelloOrganizations.Create(FSpAuthenticator) do
  begin
    try
      Result := Post([sName, sDisplayName, sDesc, sWebSite]).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

procedure TSpTrelloOrganizations.Refresh;
var
  loBook: TBookmark;
begin
  if FDataSet <> nil then
  begin
    FDataSet.DisableControls;
    loBook := FDataSet.Bookmark;
  end;
  try
    Active := False;
    Active := True;
  finally
    if FDataSet <> nil then
    begin
      if FDataSet.BookmarkValid(loBook) then
        FDataSet.GotoBookmark(loBook);
      FDataSet.EnableControls;
    end;
  end;
end;

procedure TSpTrelloOrganizations.SetActive(const Value: Boolean);
var
  oTask: ITask;
  RESTResponse: TRESTResponse;
begin
  FActive := Value;
  if FActive then
  begin
    if FSpAuthenticator = nil then
      raise Exception.Create(StrComponentAuthentica);

//    oTask := TTask.Create(
//      procedure
//      begin
//        TThread.Synchronize(nil,
//        procedure
//        begin
          with TCoreSpTrelloOrganizations.Create(FSpAuthenticator) do
          begin
            if FDataSet <> nil then
              FDataSet.DisableControls;
            try
              RESTResponse := Get([]);
              try
                FDataSet.DataInJson(RESTResponse);
              finally
                RESTResponse.Free;
              end;
            finally
              if FDataSet <> nil then
              begin
                if FDataSet.Active then
                  FDataSet.First;
                FDataSet.EnableControls;
              end;
              Free;
            end;
          end;
//        end
//      );
//      end
//    );
//    oTask.Start;
  end
  else
  begin
    if FDataSet <> nil then
      FDataSet.Close;
  end;
end;

procedure TSpTrelloOrganizations.SetSpAuthenticator(const
  Value: TSpTrelloAuthenticator);
begin
  FSpAuthenticator := Value;
end;

procedure TSpTrelloOrganizations.SetDataSet(const Value: TFDMemTable);
begin
  FDataSet := Value;
end;

end.

