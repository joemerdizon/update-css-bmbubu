<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNewUI.Master" AutoEventWireup="true" CodeBehind="TaskFiles.aspx.cs" Inherits="ManageUPPRM.dashjs.TaskFiles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        var myTeamCookie = $.cookie('TaskFilesMyTeam') ? $.cookie('TaskFilesMyTeam') : 'my';

        $(document).ready(function () {
            if (myTeamCookie == "team") {
                $("#my-radio").prop('checked', false)
                $("#team-radio").prop('checked', true)
                $('#my-label').removeClass('active');
                $('#team-label').addClass('active');
            } else {
                $("#my-radio").prop('checked', true)
                $("#team-radio").prop('checked', false)
                $('#my-label').addClass('active');
                $('#team-label').removeClass('active');
            };

            GetFiles();

            $('.my-team-switch input.toggle').on('change', function (event) {
                $.cookie('TaskFilesMyTeam', $(this).val());
                GetFiles();
            });

            $('#show-archived-files').on('change', function () {
                GetFiles();
            });

            $("#files-table").on("click", ".toggle-archive", function () {
                var approvalRequirementID = $(this).data("approvalRequirementId");
                ToggleArchive(approvalRequirementID, $(this));
            });
        });

        function GetFiles() {
            //Get team or my
            var team = $('input[name=myTeam]:checked').val() == "team";
            var showArchived = $('#show-archived-files').is(':checked');
            $("#files-table").DataTable().destroy();
            var tableBody = $("#files-table tbody");
            tableBody.html('');

            var params = {
                team: team,
                showArchived: showArchived 
            };

            var result = call('/dashjs/TaskFiles.aspx/GetFiles', JSON.stringify(params), function (response) {
                var data = response.d;

                if (data) {
                    var rows = $('#file-row').tmpl(data);
                    tableBody.html(rows);

                    applyTooltip($('.withTooltip'));
                    $("#files-table").dataTable();
                }
            });
        }

        function ToggleArchive(approvalRequirementID, element) {
            var result = call(resolveHost() + "/ManageUPWebService.asmx/ToggleArchiveApprovalRequirementFile", JSON.stringify({ approvalRequirementID: approvalRequirementID }), function (response) {
                var data = response.d;

                if (data.Success) {
                    GetFiles();
                } else {
                    bootbox.alert(data.Errors[0]);
                }
            });
        }
    </script>
    <style>
        .disabled {
            color: gray;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="page-content-wrapper">
        <div class="page-content">

            <h3 id="PageTitle" runat="server" class="hide-on-content-only page-title">Task Files
            </h3>

            <div class="page-bar">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="/dashjs/dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Task Files</a>
                    </li>
                </ul>
            </div>

            
            <div class="row margin-top-15">
                <div class="col-md-12">
                    <div class="portlet light bordered" data-team="false">
                        <div class="portlet-title" style="border: none;">
                            <div class="caption">
                                FILES
                            </div>
                            <div class="tools">
                                <a href="javascript:;" data-load="true" class="reload"></a>
                                <a href="javascript:;" class="collapse margin-right-10" data-original-title="" title=""></a>
                                <%  if (UserIsAdminOrClientAdmin())
                                    { %>
                                <div class="btn-group my-team-switch" data-toggle="buttons">
                                    <label class="btn btn-default active withTooltip" id="my-label" data-original-title="Show files from tasks that were assigned to you">
                                        <input id="my-radio" type="radio" name="myTeam" value="my" class="toggle" />
                                        My
                                    </label>
                                    <label class="btn btn-default withTooltip" id="team-label" data-original-title="Show files from tasks that were assigned to your team">
                                        <input id="team-radio" type="radio" name="myTeam" value="team" class="toggle" />
                                        Team
                                    </label>
                                </div>
                                <%} %>
                            </div>
                        </div>

                        <div class="portlet-body" style="position: relative;">
                            <div class="row margin-bottom-15">
                                <div class="col-md-12">
                                    <div class="md-checkbox-list">
                                        <div class="md-checkbox">
                                            <input type="checkbox" id="show-archived-files" class="md-check" />
                                            <label for="show-archived-files">
                                                <span class="check"></span>
                                                <span class="box"></span>
                                                Show Archived Files
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <table id="files-table" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>Uploaded File</th>
                                                <th>Owner</th>
                                                <th>Assigner</th>
                                                <th>Approver</th>
                                                <th>Report Name</th>
                                                <th>Task Name</th>
                                                <th>Task Status</th>
                                                <th>Due Date</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="loading-container"></div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    
    <script type="text/x-jquery-tmpl" id="file-row">
        {{each ApprovalRequirements}}
        <tr class="{{if Archived == true }} warning {{/if}} ">
            <td>
                {{if DocumentPath}}
                    <a href="${DocumentPath}" target="_blank">
                        ${DocumentName}&nbsp;&nbsp;{{if IsHistory }}<i class="fa fa-history withTooltip" title="This is a history file"></i>{{/if}} 
                    </a>
                {{else}}
                    ${DocumentName}
                {{/if}}
            </td>
            <td>${$data.TaskOwnerNames}</td>
            <td>${$data.TaskAssignerName}</td>
            <td>${$data.ApproverName}</td>
            <td>
                {{if $data.ReportTemplateAssignment}}
                <a target="_blank" href='/dashjs/admin/mydocs.aspx?ReportTemplateAssignmentId=${$data.ReportTemplateAssignment.ReportTemplateAssignmentID}&Team=${$('.my-team-switch input.toggle').val() == "team" ? "1" : "0"}#AssignmentStatusReport'>${$data.ReportTemplateAssignment.Name}</a>
                {{/if}}
            </td>
            <td>
                <a target="_blank" href="/dashjs/taskcontroller.aspx?TaskID=${$data.TaskID}">${$data.TaskName}</a>
            </td>
            <td>${$data.TaskStatusDescription}</td>
            <td>${$data.TaskEnd}</td>
            <td>
                {{if DocumentPath}}
                <a href="${DocumentPath}" target="_blank" style="color: #337ab7">Open</a>
                {{else}}
                <span class="disabled">Open</span>
                {{/if}}
                <button type="button" class="toggle-archive btn-link ${IsHistory ? '' : 'disabled'}" ${IsHistory ? '' : 'disabled'} data-approval-requirement-id="${ApprovalRequerimentID}">${Archived ? 'Unarchive' : 'Archive'}</button>
            </td>
        </tr>
        {{/each}}
    </script>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">

</asp:Content>
