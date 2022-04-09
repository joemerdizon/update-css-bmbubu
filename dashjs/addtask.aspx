<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addtask.aspx.cs" MasterPageFile="~/MasterNewUI.Master" Inherits="ManageUPPRM.addtask" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="RepeatSchedule" Src="~/UserControls/RepeatSchedule.ascx" %>
<%@ Register TagPrefix="uc" TagName="YouTubeModalPlayer" Src="~/UserControls/YouTubeModalPlayer.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroup" Src="~/UserControls/UsersGroup.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="TaskComments" Src="~/UserControls/TaskComments.ascx" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="../dashjs/css/kendo.common.min.css" rel="stylesheet" />
    <link href="../dashjs/css/kendo.default.min.css" rel="stylesheet" />

    <script src="js/Kendo.all.min.js"></script>
    <script src="../dashjs/js/fuelUx/scheduler.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $('select').select2({ width: '100%' });
            $("#datepicker").datepicker({ todayHighlight: true, startDate: new Date() });

            $("form").validationEngine('attach', {
                promptPosition: "topRight", focusFirstField: true,
                onValidationComplete: function (form, status) {
                    if (status) {
                        ShowWorkingModal();
                    }
                    else {
                        CloseWorkingModal();
                    };

                    return status;
                }
            });

            $('#ListApprover').on('change', function () {
                var approvalContent = $('.approvable-content');
                if ($(this).val() == '') {
                    approvalContent.find('select').val('');
                    approvalContent.hide();
                }
                else {
                    approvalContent.show();
                };
            }).trigger('change');

            $('.scheduler-repeat').scheduler();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="modals" runat="server">
    <uc:YouTubeModalPlayer runat="server" ID="YouTubeModalPlayer1"></uc:YouTubeModalPlayer>
    <uc:UsersGroupModal runat="server" ID="UsersGroupModal"></uc:UsersGroupModal>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 class="hide-on-content-only page-title">Ad-Hoc Task
                <small>A makeshift task without SQUEEZE points. It may be assigned, viewed, and actionable by other people</small>
            </h3>
            <div class="page-bar">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="tasks.aspx">Ad-Hoc Tasks</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Create</a>
                    </li>
                </ul>
            </div>

            <asp:HiddenField ID="TaskID" ClientIDMode="Static" runat="server" />

            <div class="portlet box green main-form">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-bullseye"></i>
                        <span>New Ad-Hoc Task</span>
                    </div>
                </div>
                <div class="portlet-body form">
                    <div class="form-body">
                        <asp:PlaceHolder runat="server" ID="DetailsTaskDet">
                            <h3 class="form-section subtask-modal-content assign-modal-content">Assignment Information</h3>
                            <div class="row subtask-modal-content assign-modal-content">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Assign To</label>
                                        <div class="col-md-9">
                                            <uc:UsersGroup runat="server" ID="Assignee" />
                                            <%--<select runat="server" id="AsigneeList1" class="multiselect assignees form-control" multiple="true" clientidmode="Static"></select>--%>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Assigned By</label>
                                        <div class="col-md-9">
                                            <select runat="server" id="ListAssignedBy" class="assigner form-control" multiple="false" clientidmode="Static"></select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row subtask-modal-content assign-modal-content">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Viewers</label>
                                        <div class="col-md-9">
                                            <uc:UsersGroup runat="server" ID="TaskViewers" />
                                            <%--<select runat="server" id="ListTaskViewers" class="multiselect viewers form-control" multiple="true" clientidmode="Static"></select>--%>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Backup Owners</label>
                                        <div class="col-md-9">
                                            <uc:UsersGroup runat="server" ID="TaskBackupOwners" />
                                            <%--<select runat="server" id="ListTaskBackupOwners" class="multiselect backup-owners form-control" multiple="true" clientidmode="Static"></select>--%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row subtask-modal-content assign-modal-content approver-content">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Approver</label>
                                        <div class="col-md-9">
                                            <select runat="server" id="ListApprover" class="approver form-control form-control" clientidmode="Static"></select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 approvable-content">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Approval Condition</label>
                                        <div class="col-md-9">
                                            <select runat="server" id="ApprovalConditionSelect" class="form-control" clientidmode="Static"></select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:PlaceHolder>

                        <h3 class="form-section subtask-modal-content">General Information</h3>

                        <div class="row subtask-modal-content margin-bottom-20">
                            <div class="col-md-6">
                                <label class="control-label col-md-3">Name</label>
                                <div class="col-md-9">
                                    <asp:TextBox CssClass="validate[required] taskname form-control" ID="TaskName" runat="server" ClientIDMode="Static"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="control-label col-md-3">Description</label>
                                <div class="col-md-9">
                                    <asp:TextBox ID="TaskDescription" CssClass="taskdescription form-control" runat="server" ClientIDMode="Static"></asp:TextBox>
                                </div>
                            </div>



                        </div>
                        <div class="row margin-top-20 assign-modal-content subtask-modal-content ">
                            <div class="col-md-4">
                                <label class="control-label col-md-5">Due Date</label>
                                <div class="col-md-7">
                                    <input type="text" id="datepicker" runat="server" class="dateC calender form-control" clientidmode="Static" />
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label col-md-6">Head's Up days</label>
                                <div class="col-md-6">
                                    <asp:TextBox ID="HeadsUp" CssClass="validate[required] text-input input-xsmall validate[custom[onlyNumber]] headsup form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label col-md-6">Urgent days</label>
                                <div class="col-md-6">
                                    <asp:TextBox ID="Urgent" CssClass="validate[required] text-input input-xsmall validate[custom[onlyNumber]] urgent form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <asp:PlaceHolder runat="server" ID="recurrenceContainer">
                            <h3 class="form-section subtask-modal-content">Recurrence</h3>
                            <div class="row">
                                <div class="col-md-9">
                                    <uc:RepeatSchedule ID="RepeatSchedule" runat="server" />
                                </div>
                            </div>
                        </asp:PlaceHolder>
                        <h3 class="form-section">Reference Materials</h3>
                        <div class="row">
                            <div class="col-md-12">
                                <asp:PlaceHolder ID="phUserControl" runat="server"></asp:PlaceHolder>
                            </div>
                        </div>



                        <uc:TaskComments ShowAddCommentButton="false" Collapsed="false" runat="server" ID="TaskComments"></uc:TaskComments>

                        <%--                        <div class="row">
                            <div class="col-md-12">
                                <asp:CheckBoxList ID="TaskOptions" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                    <asp:ListItem Enabled="false" Selected="True" Text="Add to Transparency Chart"></asp:ListItem>
                                    <asp:ListItem Text="Add to Calendar"></asp:ListItem>
                                </asp:CheckBoxList>
                            </div>
                        </div>--%>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="UpdateTask" runat="server" Text="Assign" OnClick="SaveTask_Click" CssClass="btn green" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" runat="server" id="repeatPatternSetValue" class="repeat-pattern-set-value" />
</asp:Content>
