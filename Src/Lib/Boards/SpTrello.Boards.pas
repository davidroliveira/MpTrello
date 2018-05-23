unit SpTrello.Boards;

interface

uses
  System.SysUtils, System.Classes, SpTrello.Authenticator,
  FireDAC.Comp.Client, Data.DB;

type
  TSpTrelloBoards = class
  private
    FSpAuthenticator: TSpTrelloAuthenticator;
    FDataSet: TFDMemTable;
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetSpAuthenticator(const Value: TSpTrelloAuthenticator);
    procedure SetDataSet(const Value: TFDMemTable);
  public
    function Insert(const AName: string): Boolean;
    procedure Refresh;
    function Delete: Boolean; overload;
    function Delete(const AId: string): Boolean; overload;
    function Edit(const AId, FieldName, Value: string): Boolean; overload;
    function Edit(FieldName, Value: string): Boolean; overload;
  published
    property SpTrelloAuthenticator: TSpTrelloAuthenticator read FSpAuthenticator write SetSpAuthenticator;
    property DataSet: TFDMemTable read FDataSet write SetDataSet;
    property Active: Boolean read FActive write SetActive default False;
  end;

implementation

uses System.Threading, Core.SpTrello.Util, REST.Client, Core.SpTrello.Boards;

resourcestring
  StrComponentAuthentica = 'Component Authenticator não encontrado.';

{ TSpTrelloBoards }

function TSpTrelloBoards.Delete: Boolean;
begin
  Result := FDataSet <> nil;
  if Result then
    Result := Self.Delete(FDataSet.FieldByName('id').AsString);
end;

function TSpTrelloBoards.Delete(const AId: string): Boolean;
begin
  Result := False;
  with TCoreSpTrelloBoards.Create(FSpAuthenticator) do
  begin
    try
      Result := Delete(AId).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TSpTrelloBoards.Edit(const AId, FieldName, Value: string): Boolean;
begin
  Result := False;
  if FSpAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  with TCoreSpTrelloBoards.Create(FSpAuthenticator) do
  begin
    try
      Result := Put(AId, FieldName, Value).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TSpTrelloBoards.Edit(FieldName, Value: string): Boolean;
begin
  Result := FDataSet <> nil;
  if Result then
    Result := Self.Edit(FDataSet.FieldByName('id').AsString, FieldName, Value);
end;

function TSpTrelloBoards.Insert(const AName: string): Boolean;
begin
  Result := False;
  if FSpAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  with TCoreSpTrelloBoards.Create(FSpAuthenticator) do
  begin
    try
      Result := Post([AName]).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

procedure TSpTrelloBoards.Refresh;
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

procedure TSpTrelloBoards.SetActive(const Value: Boolean);
var
  loTask: ITask;
  RESTResponse: TRESTResponse;
begin
  FActive := Value;
  if FActive then
  begin
    if FSpAuthenticator = nil then
      raise Exception.Create(StrComponentAuthentica);

//    if Trim(FIdOrganization) = EmptyStr then
//      raise Exception.Create(StrInformeOIdentifica);

//    loTask := TTask.Create(
//      procedure ()
//      begin
//        TThread.Synchronize(nil,
//        procedure
//        begin
//          with Ttrello_boards.Create(FIdOrganization, FSpAuthenticator) do

          with TCoreSpTrelloBoards.Create(FSpAuthenticator) do
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
//        end);
//      end
//    );
//    loTask.Start;
  end
  else
  begin
    if FDataSet <> nil then
      FDataSet.Close;
  end;
end;

procedure TSpTrelloBoards.SetSpAuthenticator(const Value: TSpTrelloAuthenticator);
begin
  FSpAuthenticator := Value;
end;

procedure TSpTrelloBoards.SetDataSet(const Value: TFDMemTable);
begin
  FDataSet := Value;
end;

end.

