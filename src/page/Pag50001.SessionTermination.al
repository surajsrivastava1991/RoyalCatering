page 50001 "Session Termination"
{
    PageType = List;
    ApplicationArea = all;
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
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("Client Type"; "Client Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("Database Name"; "Database Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("Login Datetime"; "Login Datetime")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("Server Computer Name"; "Server Computer Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("Server Instance ID"; "Server Instance ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("Server Instance Name"; "Server Instance Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("Session ID"; "Session ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("Session Unique ID"; "Session Unique ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("User SID"; "User SID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table Field';
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
                ApplicationArea = all;
                ToolTip = 'Table Field';
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
                        until SessionG.next() = 0;
                    CurrPage.Update();
                end;
            }
            action("Kill All Sessions")
            {
                ApplicationArea = all;
                ToolTip = 'Table Field';
                Promoted = true;
                PromotedIsBig = true;
                Image = Stop;
                trigger onaction()
                begin
                    if not Confirm(KillAllAessionsTxt) then
                        EXIT;
                    SessionG.RESET();
                    SessionG.SetFilter("User ID", '<>%1', UserId);
                    IF SessionG.FindSet() then
                        repeat
                            StopSession(SessionG."Session ID");

                        until SessionG.NEXT() = 0;
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