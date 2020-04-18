codeunit 50004 "Single Instance"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    procedure SetValue(var DocumentNoP: Code[20])
    begin
        DocumentNoG := DocumentNoP;
    end;

    procedure GetValue(): Code[20]
    begin
        exit(DocumentNoG);
    end;

    var
        DocumentNoG: Code[20];
}