<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUI.Master" CodeBehind="viewdtask.aspx.cs" Inherits="ManageUPPRM.viewdtask" %>

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
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>
<%--<%@ Register TagPrefix="uc" TagName="TemplateTaskAssignment" Src="~/UserControls/TemplateTaskAssignment.ascx" %>--%>
<%@ Register TagPrefix="uc" TagName="NewLabel" Src="~/UserControls/NewLabel.ascx" %>
<%@ Register TagPrefix="uc" TagName="RelatedTasks" Src="~/UserControls/RelatedTasks.ascx" %>
<%@ Register TagPrefix="uc" TagName="BackupableTaskModal" Src="~/UserControls/BackupableTaskModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="ReactionCreator" Src="~/UserControls/ReactionCreator.ascx" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../dashjs/js/fuelUx/scheduler.js"></script>
    <script src="js/Kendo.all.min.js"></script>

    <link href="../dashjs/css/kendo.common.min.css" rel="stylesheet" />
    <link href="../dashjs/css/kendo.default.min.css" rel="stylesheet" />

    <script type="text/javascript">
        $(document).ready(function () {

            $('#TblSubTasks').on('click', '.subtask-action', function () {
                var taskId = $(this).closest('tr').data('subtaskid');
                var taskName = $(this).closest('tr').find('td:first').text();

                call("../ManageUPWebService.asmx/ChangeSubTaskState", JSON.stringify({ taskId: taskId }), function (data) {
                    LoadSubTaskData(data.d);
                    showToastNotification('The status changed successfully', 'Action Item: "' + taskName + '"');
                    UpdateProgressBarValue();
                });
            });

            $('#TblSubTasks').on('click', '.references-subtask-button', function () {
                ShowReferencesModal($(this).data('taskid'));
                return false;
            });

            $('#TblSubTasks').on('click', '.subtask-comments-button', function () {
                var taskID = $(this).data('taskid');

                //Remove Comments
                var commentsTable = $("#TaskCommentsModal .mt-comments");
                commentsTable.html("");

                //Set the TaskID on TaskComments User Control
                var container = $("#TaskCommentsModal .addCommentsContainer");
                container.find(".taskCommentsTaskID input").val(taskID);

                //Load Existing Comments
                var data = JSON.stringify({
                    taskID: taskID,
                });

                var url = resolveHost() + "/ManageUPWebService.asmx/GetTaskComments";

                var success = function (response) {
                    var comments = JSON.stringify(response.d);

                    if (comments) {
                        loadComments(comments, container);
                    }
                }

                call(url, data, success);

                $("#TaskCommentsModal").modal('show');
            });

            $("#TaskCommentsModal").on('hidden.bs.modal', function () {
                var container = $("#TaskCommentsModal .addCommentsContainer");
                var taskID = container.find(".taskCommentsTaskID input").val();

                //Refresh Comments Count
                var data = JSON.stringify({
                    taskID: taskID,
                });

                var url = resolveHost() + "/ManageUPWebService.asmx/GetTaskComments";

                var success = function (response) {
                    var comments = response.d;

                    var badge = $('#TblSubTasks').find('.subtask-comments-button[data-taskid=' + taskID + '] .badge-comments');
                    badge.html(comments.length);
                }

                call(url, data, success);

            });

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
            try {
                subTasks = subTasks.sort(function compare(a, b) {
                    if (a.TaskID < b.TaskID) {
                        return -1;
                    }
                    if (a.TaskID > b.TaskID) {
                        return 1;
                    }

                    return 0;
                });
            }
            catch (e) { }

            $('#TblSubTasks tbody tr').remove();
            jQuery.each(subTasks, function (i, val) {
                AddSubTask(val);
                if (val.AllowTaskCompletition) {
                    $('#TblSubTasks tbody tr:last td:last').append("<input type='button' value='" + val.GetStatusButtonName + "' class='subtask-action btn green' />&nbsp;");
                };
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
    <div style="display: none;" id="status-container">
        <asp:Literal ID="StatusSelect" runat="server"></asp:Literal>
    </div>

    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 class="hide-on-content-only page-title">View Task</h3>

            <div class="page-bar hide-on-content-only">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="tasks.aspx">Tasks</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Task Details</a>
                    </li>
                </ul>
            </div>

            <asp:HiddenField ID="TemplateTaskID" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="TaskID" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="Approvable" ClientIDMode="Static" runat="server" />

            <div class="row">
                <div class="col-md-12" id="msg-container"></div>
            </div>

            <div class="portlet box green main-form">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-bullseye"></i>
                        <span id="ViewTaskTitle" runat="server">New Template Task</span>
                    </div>
                    <div class="actions">
                        <uc:NewLabel runat="server" ID="NewLabel" Visible="false"></uc:NewLabel>
                        <a runat="server"  id="Assign" visible="false" class="btn default">Assign</a>
                        <asp:Button ID="BackUp" Visible="false" runat="server" Text="Take it" OnClientClick="javascript:$('#BackupableTaskModal').modal('show'); return false;" CssClass="btn default" />
                    </div>
                </div>
                <div class="portlet-body form">
                    <div class="form-body">
                        <asp:PlaceHolder runat="server" ID="DetailsTaskDet">
                            <h3 class="form-section">Assignment Information</h3>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Assign To:</label>
                                        <div class="col-md-9">
                                            <p id="Assignees" runat="server" class="form-control-static"></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Assigned By:</label>
                                        <div class="col-md-9">
                                            <p id="AssignedBy" runat="server" class="form-control-static"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Viewers:</label>
                                        <div class="col-md-9">
                                            <p id="TaskViewers" runat="server" class="form-control-static"></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Backup Owners:</label>
                                        <div class="col-md-9">
                                            <p id="TaskBackUpOwners" runat="server" class="form-control-static"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Approver:</label>
                                        <div class="col-md-9">
                                            <p id="ApproverName" runat="server" class="form-control-static"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:PlaceHolder>
                        <h3 class="form-section">General Information</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Name:</label>
                                    <div class="col-md-6">
                                        <p id="TaskName" runat="server" class="form-control-static"></p>
                                    </div>
                                    <div class="col-md-3" runat="server" id="EditableNameContainer">
                                        <div class="checkbox-list">
                                            <label class="withTooltip" data-title="If checked would allow task assigner to change the task name at time of assignment">
                                                <input type="checkbox" name="nameEditable" id="NameEditable" runat="server" disabled="disabled" />
                                                Name is editable
                                            </label>
                                        </div>
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
                        <asp:PlaceHolder runat="server" ID="DetailsTaskDet2">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Due Date:</label>
                                        <div class="col-md-9">
                                            <p id="DueDate" runat="server" class="form-control-static"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:PlaceHolder>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Head's Up days:</label>
                                    <div class="col-md-9">
                                        <p id="HeadsUp" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Urgent days:</label>
                                    <div class="col-md-9">
                                        <p id="Urgent" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="AssignableContainer" runat="server">
                            <div class="col-md-6 template-content">
                                <label class="control-label col-md-3 withTooltip" title="Checking Assignable will allow the Template Task to be assigned by any user. These items will be listed under 'Opportunities' on the dashboard.">Assignable</label>
                                <div class="col-md-9" style="margin-top: 9px;">
                                    <input type="checkbox" disabled="disabled" name="mark-as-assignable" id="assignableCheckbox" runat="server"/>
                                </div>
                            </div>
                        </div>
                        <asp:PlaceHolder runat="server" ID="SquezePointsContainer" Visible="false">
                            <h3 class="form-section">SQUEEZE Points</h3>
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Safety (S)</label>
                                    <div class="col-md-6">
                                        <p id="txtSafety" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Quality (QU)</label>
                                    <div class="col-md-6">
                                        <p id="txtQuality" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Effectiveness (E)</label>
                                    <div class="col-md-6">
                                        <p id="txtEffectiveness" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Efficiency (E)</label>
                                    <div class="col-md-6">
                                        <p id="txtEfficienc" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Zest (ZE)</label>
                                    <div class="col-md-6">
                                        <p id="txtZest" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Total</label>
                                    <div class="col-md-6">
                                        <p id="txtSum" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                        </asp:PlaceHolder>

                        <uc:RelatedTasks runat="server" ID="RelatedTasks"></uc:RelatedTasks>

                        <h3 class="form-section">Action Items</h3>
                        <div class="row" id="subtasks-container">
                            <div class="col-md-12">
                                <uc:SubTaskTable runat="server" ID="SubTaskTable"></uc:SubTaskTable>
                            </div>
                        </div>
                        <uc:ViewReferences runat="server" ID="ViewReferences"></uc:ViewReferences>
                        <uc:ViewTaskTrace runat="server" ID="ViewTaskTrace"></uc:ViewTaskTrace>
                        <uc:TaskComments runat="server" ID="TaskComments"></uc:TaskComments>
                        <uc:ApprovalRequirements runat="server" ID="ApprovalRequirements"></uc:ApprovalRequirements>
                        <div class="row">
                            <asp:CheckBoxList ID="TaskOptions" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Enabled="false" Selected="True">Add to Transparency Chart</asp:ListItem>
                                <asp:ListItem Enabled="false">Add to Calendar</asp:ListItem>
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="form-actions">
                        <a id="EditRelatedTemplateTask" runat="server" class="btn btn-success" visible="false">Edit Template</a>
                        <asp:Button ID="CompleteTask" runat="server" Text="Complete" OnClick="CompleteDetailTask_Click" OnClientClick="javascript:ShowWorkingModal();" CssClass="btn green" />
                        <asp:Button ID="RejectTask" runat="server" Text="Decline" OnClientClick="javascript:$('#RejectTaskModal').modal('show'); return false;" CssClass="btn red hide-on-content-only" />
                        <asp:Button ID="EditTask" runat="server" Text="Edit" OnClick="EditTask_Click" OnClientClick="javascript:ShowWorkingModal();" CssClass="btn green hide-on-content-only" />
                        <asp:Button ID="CancelObjective" runat="server" Visible="false" Text="Cancel Assignment" OnClientClick="javascript:$('#CancelAssignmentModal').modal('show'); return false;" CssClass="btn red hide-on-content-only" />
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <uc:RejectTaskModal ID="RejectTaskModal" runat="server"></uc:RejectTaskModal>
    <uc:CancelAssignmentModal ID="CancelAssignmentModal" runat="server"></uc:CancelAssignmentModal>
    <uc:YouTubeModalPlayer runat="server" ID="YouTubeModalPlayer1"></uc:YouTubeModalPlayer>
    <uc:ViewReferencesModal runat="server" ID="ViewReferencesModal"></uc:ViewReferencesModal>
    <uc:UsersGroupModal runat="server" ID="UsersGroupModal"></uc:UsersGroupModal>
    <%--<uc:TemplateTaskAssignment runat="server" ID="TemplateTaskAssignment"></uc:TemplateTaskAssignment>--%>
    <uc:BackupableTaskModal runat="server" ID="BackupableTaskModal"></uc:BackupableTaskModal>
    
    <div id="TaskCommentsModal" class="modal bs-modal-lg fade" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-body">
                    <uc:TaskComments runat="server" ID="ActionItemTaskComments" Collapsed="False"></uc:TaskComments>
                </div>
                <div class="modal-footer">
                    <button class="btn-danger btn" data-dismiss="modal" aria-hidden="true">Close</button>
                </div>
            </div>
        </div>
    </div>
    <uc:ReactionCreator runat="server"></uc:ReactionCreator>
</asp:Content>

