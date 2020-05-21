unit UTrieTree;

interface

uses
  UTrieNode, SysUtils, Classes, Contnrs, ComCtrls, Dialogs;

type
  TTrieTree = class
  private
    FRoot: TNode;
  protected
    // Вспомогательная функция добавления элемента
    function AddHelp(wrd: string): boolean;
    // Вспомогательная процедура очистки дерева
    procedure ClearHelp;
    // Вспомогательная функция удаления
    function DeleteHelp(wrd: string): boolean;
  public
    // Конструктор TrieTree
    constructor Create;
    // Деструктор TrieTree
    destructor Destroy; override;

    // Проверка дерева на пустоту
    function IsEmpty: boolean;
    // Удаляет все эл-ты из дерева
    procedure Clear;virtual;
    // Добавить слово в дерево
    function Add(const wrd: string): boolean; virtual;
    // Поиск слова в дереве
    function Find(const wrd: string): boolean;
    // Удалить слово из дерева
    function Delete(wrd: string): boolean;   virtual;
    // Вывести слова из дерева в мемо
    procedure PrintAll(SL:TStrings);
    // Сохранить слова из дерева в файл
    procedure SaveToFile(FileName: string);
    // Загрузить слова из файла в дерево
    function LoadFromFile(FileName: string): boolean;

    // Проверка слова на отсутствие некорректных символов
    function IsCorrectWord(wrd: string): boolean;

    procedure PrintSomeWords(SL:TStrings; DelChar:char); virtual;

  end;

implementation

// Конструктор TrieTree
constructor TTrieTree.Create;
begin
  FRoot:= nil;
end;

// Деструктор TrieTree
destructor TTrieTree.Destroy;
begin
  Clear;
  inherited;
end;

// Проверка дерева на пустоту
function TTrieTree.IsEmpty: boolean;
begin
  result:= FRoot = nil;
end;

// Вспомогательная процедура очистки дерева
procedure TTrieTree.ClearHelp;
begin
  if FRoot <> nil then
    FRoot.Destroy;
  FRoot:= nil;
end;

// Удаляет все эл-ты из дерева
procedure TTrieTree.Clear;
begin
  ClearHelp;
end;

// Вспомогательная функция добавления элемента
function TTrieTree.AddHelp(wrd: string): boolean;
begin
  if FRoot = nil then
    FRoot:= TNode.Create;
  Result:= FRoot.AddWord(wrd, 1);
  if not Result and FRoot.isEmpty then
    FreeAndNil(FRoot);
end;

// Добавить слово в дерево
function TTrieTree.Add(const wrd: string): boolean;
begin
  Result:= AddHelp(wrd);
end;

// Поиск слова в дереве
function TTrieTree.Find(const wrd: string): boolean;
var
  t: TNode;
  i, len: integer;
begin
  Result:= true;
  t:= FRoot;
  i:=1;
  len:= length(wrd);
  while (i<=len) and Result and (t <> nil) do
  if not FRoot.IsCorrectChar(wrd[i]) then
    Result:= false
  else
    begin
      t:= t.Next[wrd[i]];
      i:= i+1;
    end;
  Result:= Result and (t <> nil) and t.Point;
end;

function TTrieTree.DeleteHelp(wrd: string): boolean;
begin
  Result:= (FRoot <> nil) and FRoot.DelWord(wrd, 1);
  if Result and Froot.IsEmpty then
    FreeAndNil(FRoot)
end;

// Удалить слово из дерева
function TTrieTree.Delete(wrd: string): boolean;
begin
  Result:= DeleteHelp(wrd);
end;

// Запись слов из дерева в memo
procedure TTrieTree.PrintAll(SL:TStrings);
begin
  SL.Clear;
  if FRoot <> nil then
    FRoot.PrintAll('', SL);
end;

// Сохранить слова из дерева в файл
procedure TTrieTree.SaveToFile(FileName: string);
var
  SL:TStrings;
begin
  SL:= TStringList.Create;
  PrintAll(SL);
  SL.SaveToFile(FileName);
  SL.Destroy;
end;

// Возвращает след слово в строке
function NextWord(str : string; var i : integer) : string;
var
  len : integer;
begin
  len:=length(str);
  while (i <= len)and(str[i] = ' ') do
    inc(i);
  Result:='';
  while (i <= len)and(str[i] <> ' ') do
    begin
      Result:=Result+str[i];
      inc(i);
    end
end;

// Загрузка слов из файла в дерево
function TTrieTree.LoadFromFile(FileName:string):boolean;
var
  f : TextFile;
  i,len : integer;
  str : string;
  wrd : string;
begin
  ClearHelp;
  Result:=true;
  assignfile(f,FileName);
  reset(f);
  while not eof(f) and Result do
    begin
      readln(f, str);
      str:=Trim(str);
      i:=1;
      Result:=true;
      len:=length(str);
      while (i<=len) {and Result} do
        begin
          wrd:=NextWord(str, i);
          Result:= IsCorrectWord(wrd) and addHelp(wrd);
        end;
    end;
  CloseFile(f);
end;

// Проверка слова на отсутствие некорректных символов
function TTrieTree.IsCorrectWord(wrd: string): boolean;
var
  i, len : integer;
begin
  i:=1;
  len:=Length(wrd);
  Result:=len<>0;
  while (i<=len) and Result do
    begin
      Result:= FRoot.IsCorrectChar(wrd[i]);
      inc(i);
    end;
end;

procedure TTrieTree.PrintSomeWords;
var
  Str:string;
begin
  SL.Clear;
  Str:='';
  if FRoot <> nil then
    FRoot.PrintSomeWords(Str, SL, DelChar);
end;

end.
