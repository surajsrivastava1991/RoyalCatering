page 50001 Sessions
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Active Session";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Client Computer Name"; "Client Computer Name")
                {
                    ApplicationArea = All;
                }
                field("Client Type"; "Client Type")
                {
                    ApplicationArea = All;
                }
                field("Database Name"; "Database Name")
                {
                    ApplicationArea = All;
                }
                field("Login Datetime"; "Login Datetime")
                {
                    ApplicationArea = All;
                }
                field("Server Computer Name"; "Server Computer Name")
                {
                    ApplicationArea = All;
                }
                field("Server Instance ID"; "Server Instance ID")
                {
                    ApplicationArea = All;
                }
                field("Server Instance Name"; "Server Instance Name")
                {
                    ApplicationArea = All;
                }
                field("Session ID"; "Session ID")
                {
                    ApplicationArea = All;
                }
                field("Session Unique ID"; "Session Unique ID")
                {
                    ApplicationArea = All;
                }
                field("User SID"; "User SID")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Kill Selected Sessions")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Cancel;
                trigger OnAction();
                begin
                    if not Confirm(KillaSelectedSessionsTxt) then
                        EXIT;
                    CurrPage.SetSelectionFilter(SessionG);
                    if SessionG.FindSet() then
                        repeat
                            SessionG2.Reset();
                            SessionG2.SetRange("User ID", SessionG."User ID");
                            if SessionG2.FindSet() then
                                StopSession(SessionG2."Session ID");
                        until SessionG.next = 0;
                    CurrPage.Update();
                end;
            }
            action("Kill All Sessions")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                Image = Stop;
                trigger onaction()
                begin
                    if not Confirm(KillAllAessionsTxt) then
                        EXIT;
                    SessionG.RESET;
                    SessionG.SetFilter("User ID", '<>%1', UserId);
                    IF SessionG.FindSet() then
                        repeat
                            StopSession(SessionG."Session ID");

                        until SessionG.NEXT = 0;
                    CurrPage.Update();
                end;

            }
        }
    }
    var
        SessionG: Record "Active Session";
        SessionG2: Record "Active Session";
        KillaSelectedSessionsTxt: Label 'Do you want to kill selected sessions?';
        KillAllAessionsTxt: Label 'Do you want to kill all the sessions?';
}