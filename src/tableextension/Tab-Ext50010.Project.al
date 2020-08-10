tableextension 50010 "Project" extends Job
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            trigger OnAfterValidate()
            var
                DimValL: Record "Dimension Value";
                GenLedSetupL: Record "General Ledger Setup";
            begin
                GenLedSetupL.Get();
                DimValL.Reset();
                DimValL.SetRange("Dimension Code", GenLedSetupL."Project Dimension Code :");
                DimValL.SetRange(Code, "Global Dimension 1 Code");
                if DimValL.FindFirst() then
                    "Project Description" := DimValL.Name;

            end;
        }
        field(50000; "Kitchen Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location where("Location Type" = filter('Bulk Kitchen|Project Kitchen'));
            trigger OnValidate()
            var
                LocationL: Record Location;
            begin
                if LocationL.Get("Kitchen Location") then
                    "Kitchen Location Name" := LocationL.Name
                else
                    "Kitchen Location Name" := '';
            end;
        }
        field(50001; "Kitchen Location Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50002; "Project Status"; option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Open","InProcess","Hold","Closed";
            OptionCaption = 'Open,InProcess,Hold,Closed';
        }
        field(50003; "Project Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50004; "Project Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location where("Location Type" = filter('Project Kitchen'));
            trigger OnValidate()
            var
                LocationL: Record Location;
            begin
                if LocationL.Get("Project Location") then
                    "Project Location Name" := LocationL.Name
                else
                    "Project Location Name" := '';
            end;
        }
        field(50005; "Project Location Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}