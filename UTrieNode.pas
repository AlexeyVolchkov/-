unit UTrieNode;

interface

uses
  SysUtils, Classes, Contnrs, ComCtrls;

const
  LowCh = 'a';
  HighCh = 'z';

type
  TIndex = LowCh..HighCh;

  TNode = class
  private
    FPoint: boolean;
    FNext: array[TIndex] of TNode;
  protected
    // Возвращает узел по индексу ch
    function GetNext(ch: TIndex): TNode;
    // Устанавливает узел value по индексу ch
    procedure SetNext(ch: TIndex; value: TNode);
  public
    // Конструктор узла
    constructor Create;
    // Деструктор узла
    destructor Destroy; override;

    // Проверка узла на пустоту
    function isEmpty:boolean;
    // Провекра символа на корректность
    function IsCorrectChar(ch: char): boolean;
    // Добавление слова
    function AddWord(var wrd: string; i: integer): boolean;
    // Поиск слова
    function FindWord(var wrd: string; i: integer): boolean;
    // Удаление слова
    function DelWord(var wrd: string; i: integer): boolean;
    // Вывод всех слов в мемо
    procedure PrintAll(wrd:string; SL:TStrings);

    procedure PrintSomeWords(wrd:string; SL:TStrings; DelChar:char);

    // Свойство для поля FPoint
    property Point: boolean read FPoint write FPoint;
    // Свойство для поля Fnext
    property Next[index: TIndex]: TNode read GetNext write SetNext;
  end;

implementation

// Возвращает узел по индексу ch
function TNode.GetNext(ch: TIndex): TNode;
begin
  result:= FNext[ch];
end;

// Устанавливает узел value по индексу ch
procedure TNode.SetNext(ch: TIndex; value: TNode);
begin
  if FNext[ch] <> value then
    begin
      FreeAndNil(FNext[ch]);
      FNext[ch]:= value;
    end;
end;

// Проверка узла на пустоту
function TNode.isEmpty:boolean;
var
  ch: TIndex;
begin
  ch:= LowCh;
  Result:= not FPoint and (FNext[ch] = nil);
  if Result then
    repeat
      inc(ch);
      Result:= FNext[ch] = nil;
    until (ch = HighCh) or not Result;
end;

// Конструктор узла
constructor TNode.Create;
var
  ch: TIndex;
begin
  Point:= false;
  for ch:= LowCh to HighCh do
    FNext[ch]:= nil;
end;

// Деструктор узла
destructor TNode.Destroy;
var
  ch: TIndex;
begin
  for ch:= LowCh to HighCh do
    if FNext[ch] <> nil then
      FNext[ch].Destroy;
    inherited;
end;

// Провекра символа на корректность
function TNode.IsCorrectChar(ch: char): boolean;
begin
  result:= (ch >= LowCh) and (ch <= HighCh);
end;

// Добавление слова
function TNode.AddWord(var wrd: string; i: integer): boolean;
begin
  if i > length(wrd) then
    begin
      result:= not FPoint;
      FPoint:= true;
    end
  else
    if not IsCorrectChar(wrd[i]) then
      result:= false
    else
      begin
        if FNext[wrd[i]] = nil then
          FNext[wrd[i]]:=TNode.Create;
        //Рекурсия
        result:= FNext[wrd[i]].AddWord(wrd, i+1);

        if not result and FNext[wrd[i]].isEmpty then
          FreeAndNil(FNext[wrd[i]]);
      end;
end;

// Поиск слова
function TNode.FindWord(var wrd: string; i: integer): boolean;
begin
  if i > length(wrd) then
    result:= FPoint
  else
    result:= IsCorrectChar(wrd[i]) and (FNext[wrd[i]] <> nil) and FNext[wrd[i]].FindWord(wrd, i+1);
end;

// Удаление слова
function TNode.DelWord(var wrd: string; i: integer): boolean;
begin
  if i > length(wrd) then
    begin
      result:= FPoint;
      FPoint:= false;
    end
  else
    if not IsCorrectChar(wrd[i]) or (FNext[wrd[i]] = nil) then
      result:= false
    else
      begin
        result:= FNext[wrd[i]].DelWord(wrd, i+1);
        if result and FNext[wrd[i]].IsEmpty then
          FreeAndNil(FNext[wrd[i]]);
      end;
end;

//Рекурсивная функция принта всех слов от заданного звена
procedure TNode.PrintAll(wrd:string; SL:TStrings);
var
  ch:Tindex;
begin
  if Fpoint then
    SL.Add(wrd);
  for ch:= lowCh to HighCh do
    if FNext[ch] <> nil then
      begin
        wrd:=wrd+ch;
        FNext[ch].PrintAll(wrd, sl);
        SetLength(wrd,length(wrd)-1);
      end;
end;

procedure TNode.PrintSomeWords(wrd:string; SL:TStrings; DelChar:char);
var
  ch:TIndex;
begin
  if FPoint then
    SL.Add(wrd);
  for ch:= lowCh to HighCh do
    if (FNext[ch] <> nil) and (DelChar <> ch) then
      begin
        wrd:=wrd+ch;
        FNext[ch].PrintSomeWords(wrd, sl, DelChar);
        SetLength(wrd,length(wrd)-1);
      end;
end;


end.

