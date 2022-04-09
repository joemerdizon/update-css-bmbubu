<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUI.Master" CodeBehind="viewtask.aspx.cs" Inherits="ManageUPPRM.viewtask" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="ViewReferences" Src="~/UserControls/ViewReferences.ascx" %>
<%@ Register TagPrefix="uc" TagName="RepeatSchedule" Src="~/UserControls/RepeatSchedule.ascx" %>
<%@ Register TagPrefix="uc" TagName="YouTubeModalPlayer" Src="~/UserControls/YouTubeModalPlayer.ascx" %>
<%@ Register TagPrefix="uc" TagName="ViewTaskTrace" Src="~/UserControls/ViewTaskTrace.ascx" %>
<%@ Register TagPrefix="uc" TagName="RejectTaskModal" Src="~/UserControls/RejectTaskModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="ApprovalRequirements" Src="~/UserControls/ApprovalRequirements.ascx" %>
<%@ Register TagPrefix="uc" TagName="TaskComments" Src="~/UserControls/TaskComments.ascx" %>
<%@ Register TagPrefix="uc" TagName="NewLabel" Src="~/UserControls/NewLabel.ascx" %>
<%@ Register TagPrefix="uc" TagName="RelatedTasks" Src="~/UserControls/RelatedTasks.ascx" %>
<%@ Register TagPrefix="uc" TagName="CancelAssignmentModal" Src="~/UserControls/CancelAssignmentModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="BackupableTaskModal" Src="~/UserControls/BackupableTaskModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="ReactionCreator" Src="~/UserControls/ReactionCreator.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="js/Kendo.all.min.js"></script>

    <script src="<%= Page.ContentLastWrite("/dashjs/js/keepAuthenticationAlive.js")%>"></script>
    <link href="../dashjs/css/kendo.common.min.css" rel="stylesheet" />
    <link href="../dashjs/css/kendo.default.min.css" rel="stylesheet" />

    <script type="text/javascript">
        $(document).ready(function () {
            ShowResourceList();
            ShowAttachmentList();
            useDashInstedOfEmptyContent();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 class="hide-on-content-only page-title">View Task</h3>

            <div class="page-bar">
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

            <asp:HiddenField ClientIDMode="static" ID="TaskID" runat="server" />

            <div class="row">
                <div class="col-md-12" id="msg-container"></div>
            </div>

            <div class="portlet box green main-form">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-bullseye"></i>
                        <span id="ViewTaskTitle" runat="server">New Task</span>
                    </div>
                    <div class="actions">
                        <uc:NewLabel runat="server" ID="NewLabel" Visible="false"></uc:NewLabel>
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
                                    <label class="control-label col-md-3">Due Date:</label>
                                    <div class="col-md-9">
                                        <p id="DueDate" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <uc:RelatedTasks runat="server" ID="RelatedTasks"></uc:RelatedTasks>
                        <uc:ViewReferences runat="server" ID="ViewReferences"></uc:ViewReferences>

                        <uc:ViewTaskTrace runat="server" ID="ViewTaskTrace"></uc:ViewTaskTrace>
                        <uc:TaskComments runat="server" ID="TaskComments" ShowNotificationCheckBoxes="true"></uc:TaskComments>
                        <uc:ApprovalRequirements runat="server" ID="ApprovalRequirements"></uc:ApprovalRequirements>
                        <div class="row">
                            <asp:CheckBoxList ID="TaskOptions" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Enabled="false" Selected="True">Add to Transparency Chart</asp:ListItem>
                                <%--<asp:ListItem>Add to Calendar</asp:ListItem>--%>
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="CompleteTask" runat="server" Text="Complete" OnClick="CompleteTask_Click" OnClientClick="javascript:ShowWorkingModal();" CssClass="btn green" />
                        <asp:Button ID="RejectTask" runat="server" Text="Decline" OnClientClick="javascript:$('#RejectTaskModal').modal('show'); return false;" CssClass="btn red" />
                        <asp:Button ID="EditTask" runat="server" Text="Edit" OnClick="EditTask_Click" OnClientClick="javascript:ShowWorkingModal();" CssClass="btn green" />
                        <asp:Button ID="CancelObjective" runat="server" Visible="false" Text="Cancel Assignment" OnClientClick="javascript:$('#CancelAssignmentModal').modal('show'); return false;" CssClass="btn red" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" runat="server" id="repeatPatternSetValue" class="repeat-pattern-set-value" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <uc:YouTubeModalPlayer runat="server" ID="YouTubeModalPlayer"></uc:YouTubeModalPlayer>
    <uc:CancelAssignmentModal ID="CancelAssignmentModal" runat="server"></uc:CancelAssignmentModal>
    <uc:RejectTaskModal ID="RejectTaskModal" runat="server"></uc:RejectTaskModal>
    <uc:BackupableTaskModal runat="server" ID="BackupableTaskModal"></uc:BackupableTaskModal>
    <uc:ReactionCreator runat="server"></uc:ReactionCreator>
</asp:Content>
