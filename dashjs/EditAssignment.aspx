<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditAssignment.aspx.cs" MasterPageFile="~/MasterNewUI.Master" Inherits="ManageUPPRM.dashjs.EditAssignment" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="ViewReferences" Src="~/UserControls/ViewReferences.ascx" %>
<%@ Register TagPrefix="uc" TagName="YouTubeModalPlayer" Src="~/UserControls/YouTubeModalPlayer.ascx" %>
<%@ Register TagPrefix="uc" TagName="SubTaskTable" Src="~/UserControls/SubTaskTable.ascx" %>
<%@ Register TagPrefix="uc" TagName="ViewReferencesModal" Src="~/UserControls/ViewReferencesModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="ViewTaskTrace" Src="~/UserControls/ViewTaskTrace.ascx" %>
<%@ Register TagPrefix="uc" TagName="ApprovalRequirements" Src="~/UserControls/ApprovalRequirements.ascx" %>
<%@ Register TagPrefix="uc" TagName="RejectTaskModal" Src="~/UserControls/RejectTaskModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="CancelAssignmentModal" Src="~/UserControls/CancelAssignmentModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="TaskComments" Src="~/UserControls/TaskComments.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroup" Src="~/UserControls/UsersGroup.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="TemplateTaskAssignment" Src="~/UserControls/TemplateTaskAssignment.ascx" %>
<%@ Register TagPrefix="uc" TagName="NewLabel" Src="~/UserControls/NewLabel.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../dashjs/js/fuelUx/scheduler.js"></script>
    <script src="js/Kendo.all.min.js"></script>

    <link href="../dashjs/css/kendo.common.min.css" rel="stylesheet" />
    <link href="../dashjs/css/kendo.default.min.css" rel="stylesheet" />

    <script type="text/javascript">
        $(document).ready(function () {

            $('.references-subtask-button').on('click', function () {
                ShowReferencesModal($(this).data('taskid'));
                return false;
            });

            $(".subtask-comments-button").hide();
            $("input.datepicker").datepicker({ todayHighlight: true, startDate: new Date() });

            ShowResourceList();
            ShowAttachmentList();
            useDashInstedOfEmptyContent();
        });

        function LoadSubTasks(userSubTasks) {
            var statusSelect = $('#status-container');

            var subTasks = $.parseJSON(userSubTasks);
            LoadSubTaskData(subTasks);
        };

        function LoadSubTaskData(subTasks) {
            $('#TblSubTasks tbody tr').remove();
            jQuery.each(subTasks, function (i, val) {
                AddSubTask(val);
            });

            if ($('#TblSubTasks tbody tr').length == 0) {
                //$('#subtasks-container').hide();
            };

            $('.editable-action').hide();
        };

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input type="hidden" id="ReadOnlyTask" value="true" />

    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 class="hide-on-content-only page-title">Edit Objective Assignment</h3>

            <div class="page-bar hide-on-content-only">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="tasks.aspx">Objectives</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Objective Assignment</a>
                    </li>
                </ul>
            </div>

            <asp:HiddenField ID="TaskID" ClientIDMode="Static" runat="server" />

            <div class="row">
                <div class="col-md-12" id="msg-container"></div>
            </div>

            <div class="portlet box green main-form">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-bullseye"></i>
                        <span id="ViewTaskTitle" runat="server">Objective</span>
                    </div>
                </div>
                <div class="portlet-body form">
                    <div class="form-body">
                        <h3 class="form-section">Assignment Information</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Assign To:</label>
                                    <div class="col-md-9">
                                        <p id="Assignee" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Assigned By</label>
                                    <div class="col-md-9">
                                        <select runat="server" id="AssignedBy" class="assigner form-control" multiple="false"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row subtask-modal-content assign-modal-content">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Viewers</label>
                                    <div class="col-md-9 viewers">
                                        <uc:UsersGroup runat="server" ID="TaskViewers" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Backup Owners</label>
                                    <div class="col-md-9 backup-owners">
                                        <uc:UsersGroup runat="server" ID="BackupOwners" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row subtask-modal-content assign-modal-content approver-content">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Approver</label>
                                    <div class="col-md-9">
                                        <select runat="server" id="Approver" class="approver form-control"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <h3 class="form-section">General Information</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Name:</label>
                                    <div class="col-md-9">
                                        <p id="TaskName" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Description:</label>
                                    <div class="col-md-9">
                                        <p id="TaskDesc" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Category:</label>
                                    <div class="col-md-9">
                                        <p id="TaskCategories" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Sub Category:</label>
                                    <div class="col-md-9">
                                        <p id="TaskSubCategories" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row margin-top-20 assign-modal-content subtask-modal-content ">
                            <div class="col-md-4">
                                <label class="control-label col-md-5">Due Date</label>
                                <div class="col-md-7">
                                    <input type="text" class="text-input datepicker input-small form-control" id="DueDate" runat="server" />
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label col-md-6">Head's Up days</label>
                                <div class="col-md-6">
                                    <asp:TextBox ID="headsup" CssClass="validate[required] text-input input-xsmall validate[custom[onlyNumber]] headsup form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label col-md-6">Urgent days</label>
                                <div class="col-md-6">
                                    <asp:TextBox ID="Urgent" CssClass="validate[required] text-input input-xsmall validate[custom[onlyNumber]] urgent form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <h3 class="form-section">Action Items</h3>
                        <div class="row" id="subtasks-container">
                            <div class="col-md-12">
                                <uc:SubTaskTable runat="server" ID="SubTaskTable"></uc:SubTaskTable>
                            </div>
                        </div>
                        <uc:ViewReferences runat="server" ID="ViewReferences"></uc:ViewReferences>
                    </div>
                    <div class="form-actions hide-on-content-only">
                        <asp:Button ID="Edit" runat="server" Text="Save" CssClass="btn green" OnClick="EditAssignment_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <uc:YouTubeModalPlayer runat="server" ID="YouTubeModalPlayer1"></uc:YouTubeModalPlayer>
    <uc:ViewReferencesModal runat="server" ID="ViewReferencesModal"></uc:ViewReferencesModal>
    <uc:UsersGroupModal runat="server" ID="UsersGroupModal"></uc:UsersGroupModal>
</asp:Content>
