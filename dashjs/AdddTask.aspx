<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUi.Master" CodeBehind="AdddTask.aspx.cs" Inherits="ManageUPPRM.AdddTask" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%--<%@ Register Src="~/dashjs/SubTask.ascx" TagName="SubTask" TagPrefix="uc" %>--%>

<%@ Register TagPrefix="uc" TagName="RepeatSchedule" Src="~/UserControls/RepeatSchedule.ascx" %>
<%@ Register TagPrefix="uc" TagName="CategoryAndSubcategory" Src="~/UserControls/CategoryAndSubcategory.ascx" %>
<%@ Register TagPrefix="uc" TagName="CategoryAndSubcategoryModal" Src="~/UserControls/CategoryAndSubcategoryModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="YouTubeModalPlayer" Src="~/UserControls/YouTubeModalPlayer.ascx" %>
<%@ Register TagPrefix="uc" TagName="ReferenceMaterialEditonModal" Src="~/UserControls/ReferenceMaterialEditonModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="SubTaskTable" Src="~/UserControls/SubTaskTable.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroup" Src="~/UserControls/UsersGroup.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="js/categoryAndSubcategoryLoader.js"></script>
    <script src="<%= Page.ContentLastWrite("/dashjs/js/keepAuthenticationAlive.js")%>"></script>

    <link href="../dashjs/css/kendo.common.min.css" rel="stylesheet" />
    <link href="../dashjs/css/kendo.default.min.css" rel="stylesheet" />

    <script src="js/bootbox.min.js"></script>
    <script src="js/Kendo.all.min.js"></script>

    <script type="text/javascript">
        window.selectedFiles = [];

        var categoriesOptions = '';
        $(document).ready(function () {
            $('#CancelTaskbtn').on('click', function () {
                if (inIframe()) {
                    window.parent.closeAddTaskIframeAndAddTask();
                    return false;
                }
                else {
                    ReloadPage();
                };
            });

            $(".main-form .score-container .score").on('keyup', function () {
                $(".main-form .score-container #txtSum").val(calculateSum($(".main-form")));
                checkParentTaskScores();
            });

            $("form").validationEngine('attach', {
                promptPosition: "topLeft", focusFirstField: true,
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

            initializeSubTaskModal();

            $('.not-template-task').hide();
            $('.approver-content').hide();

            if ($('#TaskID').val() != '') {
                $('.not-template-task').show();
                $('.approver-content').show();

                $('.template-task-content').hide();
            }
            else {
                if ($('.template-task-content').find('select').length == 0) {
                    $('.template-task-content').hide();
                };
                $('.main-form .assign-modal-content').remove();
            };

            $('.mark-as-approver-container #markForApproval').on('change', function () {
                if ($(this).is(':checked')) {
                    if ($('#TaskID').val() != '') {
                        $('.approver-content').show();
                    }
                    else {
                        hideApproverContent();
                    };

                    $('.approvable-content').show();
                }
                else {
                    hideApproverContent();
                    $('.approvable-content').hide();
                };
            });

            var hideApproverContent = function () {
                $('.approver-content').hide();
                $('.approver-content select').val('');
            };

            $('#markForApproval').trigger('change');
            $("input.datepicker").datepicker({ todayHighlight: true, startDate: new Date() });

            if (inIframe()) {
                $('#teamplate-tasks-tab').closest('li').remove();

                if ($('#TaskAdded').val() == "true") {
                    window.parent.closeAddTaskIframeAndAddTask($('#TemplateTaskID').val());
                };
            }
            else if ($('#TaskAdded').val() == "true") {
                CreateSuccess('The template was submitted for approval.');
            };

            $('select').select2({ width: '100%' });

            //Sub-category selection/ editable checkbox 

            var nameEditable = $('#<%=NameEditable.ClientID%>');
            var subcategoryList = $('.main-form div.subcategory-list:first');

            $('.main-form select.subcategory-list').on('change', function () {
                if ($(this).val()) {
                    nameEditable.removeProp('disabled');
                }
                else {
                    nameEditable.prop('disabled', 'disabled');
                    nameEditable.prop('checked', false);
                };

                nameEditable.trigger('change')
                $.uniform.update(nameEditable);
            });

            nameEditable.on('change', function () {
                if ($(this).is(':checked')) {
                    $('#<%=TaskName.ClientID%>').val(subcategoryList.find('.select2-chosen').text()).prop('readonly', 'readonly');
                }
                else {
                    $('#<%=TaskName.ClientID%>').removeProp('readonly');
                };
            });

            $('.main-form select.subcategory-list').trigger('change');

            $("#<%=markForApproval.ClientID%>").change(function () {
                var completionApprovalRequired = $(this).is(":checked");
                var approvalConditionSelect = $("#<%=ApprovalConditionSelect.ClientID%>");

                if (completionApprovalRequired) {
                    approvalConditionSelect.prop('disabled', false);
                } else {
                    approvalConditionSelect.prop('disabled', true);
                }
            });
        });

        function isATemplateTask() {
            return $('#TemplateTaskID').val() != '' || $('#TaskID').val() == '';
        };

        var subtaskCategories;

        function checkParentTaskScores() {
            var mainTaskContainer = $('.main-form'),
                tblSubTasks = $('#TblSubTasks');

            var mainSafety = mainTaskContainer.find('.txtSafety:first'),
            mainQuality = mainTaskContainer.find('.txtQuality:first'),
            mainEffectiveness = mainTaskContainer.find('.txtEffectiveness:first'),
            mainEfficienc = mainTaskContainer.find('.txtEfficienc:first'),
            mainZest = mainTaskContainer.find('.txtZest:first');
            mainSum = mainTaskContainer.find('.txtSum:first');

            if (tblSubTasks.find('tbody tr').length > 0) {

                var sumtxtSafety = 0,
                    sumtxtQuality = 0,
                    sumtxtEffectiveness = 0,
                    sumtxtEfficienc = 0,
                    sumtxtZest = 0,
                    sumtxtSum = 0;

                tblSubTasks.find('.TaskSafety').each(function () {
                    sumtxtSafety += Number($(this).val());
                });
                tblSubTasks.find('.TaskQuality').each(function () {
                    sumtxtQuality += Number($(this).val());
                });
                tblSubTasks.find('.TaskEffectiveness').each(function () {
                    sumtxtEffectiveness += Number($(this).val());
                });
                tblSubTasks.find('.TaskEfficienc').each(function () {
                    sumtxtEfficienc += Number($(this).val());
                });
                tblSubTasks.find('.TaskZest').each(function () {
                    sumtxtZest += Number($(this).val());
                });
                tblSubTasks.find('.TaskSum').each(function () {
                    sumtxtSum += Number($(this).val());
                });

                mainSafety.attr('readonly', true).val(sumtxtSafety);
                mainQuality.attr('readonly', true).val(sumtxtQuality);
                mainEffectiveness.attr('readonly', true).val(sumtxtEffectiveness);
                mainEfficienc.attr('readonly', true).val(sumtxtEfficienc);
                mainZest.attr('readonly', true).val(sumtxtZest);
                mainSum.attr('readonly', true).val(sumtxtSum);
            }
            else {
                mainSafety.removeAttr('readonly');
                mainQuality.removeAttr('readonly');
                mainEffectiveness.removeAttr('readonly');
                mainEfficienc.removeAttr('readonly');
                mainZest.removeAttr('readonly');
            };
        };

        function ShowSubTaskModal(subTaskContainer) {
            setSubTaskModalValues(subTaskContainer);
            $('#AddSubtaskModal').modal('show');
        };

        function setSubTaskModalValues(subTaskContainer) {
            var subTaskModal = $('#AddSubtaskModal');
            if (subTaskContainer != undefined) {
                var taskID = subTaskContainer.find('.TaskID').val()
                    taskName = subTaskContainer.find('.TaskName').val(),
                    taskdescription = subTaskContainer.find('.TaskDescription').val(),
                    categoryList = subTaskContainer.find('.TaskCategoryList').val(),
                    taskSafety = subTaskContainer.find('.TaskSafety').val(),
                    taskQuality = subTaskContainer.find('.TaskQuality').val(),
                    taskEffectiveness = subTaskContainer.find('.TaskEffectiveness').val(),
                    taskEfficienc = subTaskContainer.find('.TaskEfficienc').val(),
                    taskZest = subTaskContainer.find('.TaskZest').val(),
                    taskSum = subTaskContainer.find('.TaskSum').val(),

                    taskAssignees = subTaskContainer.find('.TaskAssignees').val(),
                    taskViewers = subTaskContainer.find('.TaskViewers').val(),
                    taskBackupOwners = subTaskContainer.find('.TaskBackupOwners').val(),

                    taskAssigner = subTaskContainer.find('.TaskAssigner').val(),
                    taskApprover = subTaskContainer.find('.TaskApprover').val(),
                    taskDueDate = subTaskContainer.find('.TaskDueDate').val(),
                    editRow = subTaskContainer.data('row');

                subtaskCategories.setSelectedSubCategory(subTaskContainer.find('.TaskSubCategoryList').val());

            } else {
                var taskName = '',
                    taskdescription = '',
                    categoryList = '',
                    taskSafety = '',
                    taskQuality = '',
                    taskEffectiveness = '',
                    taskEfficienc = '',
                    taskZest = '',
                    taskSum = '',

                    taskAssignees = '',
                    taskViewers = '',
                    taskBackupOwners = '',

                    taskAssigner = '',
                    taskApprover = '',
                    taskDueDate = '',

                    editRow = -1;
            };

            subTaskModal.find('input.ActionItemTaskID').val(taskID);
            subTaskModal.find('input.taskname').val(taskName);
            subTaskModal.find('input.taskdescription').val(taskdescription);

            subTaskModal.find('.category-list').val(categoryList).trigger('change');

            subTaskModal.find('input.txtSafety').val(taskSafety);
            subTaskModal.find('input.txtQuality').val(taskQuality);
            subTaskModal.find('input.txtEffectiveness').val(taskEffectiveness);
            subTaskModal.find('input.txtEfficienc').val(taskEfficienc);
            subTaskModal.find('input.txtZest').val(taskZest);
            subTaskModal.find('input.txtSum').val(taskSum);

            subTaskModal.find('.assign-to .selected-users').val(taskAssignees).trigger('change');
            subTaskModal.find('.viewers .selected-users').val(taskViewers).trigger('change');
            subTaskModal.find('.backup-owners .selected-users').val(taskBackupOwners).trigger('change');

            subTaskModal.find('select.assigner').val(taskAssigner).trigger('change');
            subTaskModal.find('select.approver').val(taskApprover).trigger('change');

            subTaskModal.find('input.calender').val(taskDueDate);

            subTaskModal.data('edit-row', editRow);
        };

        function LoadSubTasks(userSubTasks) {
            var subTasks = $.parseJSON(userSubTasks);
            jQuery.each(subTasks, function (i, val) {
                AddSubTask(val);
            });

            checkParentTaskScores();
        };

        function initializeSubTaskModal() {
            var subTaskModal = $('#AddSubtaskModal');

            //subTaskModal.find('tbody.main-body').prepend($('.subtask-modal-content').clone().show());
            //subTaskModal.find('select, input.calender, input[type="text"], div').removeAttr('id').removeAttr('name');


            //subTaskModal.find('select option').removeAttr('selected');
            subTaskModal.find('div.calender input.calender').datepicker({ todayHighlight: true, startDate: new Date() });

            if (isATemplateTask()) {
                subTaskModal.find('.assign-modal-content').remove();
            };

            subTaskModal.find(".score").removeAttr('readonly').on('keyup', function () {
                subTaskModal.find("input.txtSum").val(calculateSum(subTaskModal));
                checkParentTaskScores();
            });

            subtaskCategories = initializeCategoryAndSubcategory(subTaskModal);

            subTaskModal.find('#add-subtask-template').on('click', function () {
                var data = {
                    TaskID: subTaskModal.find('input.ActionItemTaskID').val(),
                    TaskName: subTaskModal.find('input.taskname').val(),
                    TaskDescription: subTaskModal.find('input.taskdescription').val(),

                    TaskCategory: subTaskModal.find('select.category-list option:selected').text(),
                    TaskCategoryID: subTaskModal.find('select.category-list').val(),
                    TaskSubCategory: subTaskModal.find('select.subcategory-list option:selected').text(),
                    TaskSubCategoryID: subTaskModal.find('select.subcategory-list').val(),

                    SafetyPoints: subTaskModal.find('input.txtSafety').val(),
                    QualityPoints: subTaskModal.find('input.txtQuality').val(),
                    EffectivenessPoints: subTaskModal.find('input.txtEffectiveness').val(),
                    EfficiencyPoints: subTaskModal.find('input.txtEfficienc').val(),
                    ZestPoints: subTaskModal.find('input.txtZest').val(),
                    SumPoints: subTaskModal.find('input.txtSum').val(),

                    TaskOwner: safeJoin(subTaskModal.find('div.assign-to .selected-users').val()),
                    TaskOwnerNames: subTaskModal.find('div.assign-to .selected-descriptions').val(),
                    TaskViewers: safeJoin(subTaskModal.find('div.viewers .selected-users').val()),
                    TaskViewersNames: subTaskModal.find('div.viewers .selected-descriptions').val(),
                    TaskBackUpOwners: safeJoin(subTaskModal.find('div.backup-owners .selected-users').val()),
                    TaskBackUpOwnersNames: subTaskModal.find('div.backup-owners .selected-descriptions').val(),
                    TaskAssigner: subTaskModal.find('select.assigner').val(),
                    TaskAssignerName: subTaskModal.find('select.assigner option:selected').text(),
                    TaskApprover: subTaskModal.find('select.approver').val(),

                    TaskEnd: subTaskModal.find('input.calender').val(),

                    UserDocuments: [],
                    Resources: []
                };

                if (subTaskModal.data('edit-row') > -1) {
                    var taskData = $('#TblSubTasks tr[data-row="' + subTaskModal.data('edit-row') + '"]');
                    data.UserDocuments = $.parseJSON(taskData.find('.TaskAttachments').val());
                    data.Resources = $.parseJSON(taskData.find('.TaskReferences').val());
                    removeSubTask(subTaskModal.data('edit-row'));
                };

                AddSubTask(data);
                checkParentTaskScores();

                subTaskModal.modal('hide');
                return false;
            });
        };

        function removeSubTask(row) {
            $('#TblSubTasks tr[data-row="' + row + '"]').remove();
            checkParentTaskScores();
        };

        function calculateSum(container) {
            var sum = 0, scores;

            if (container.hasClass('modal')) {
                scores = container.find(".score");
            }
            else {
                scores = container.find('.score-container .score');
            };

            //iterate through each textboxes and add the values
            scores.each(function () {
                //add only if the value is number
                if (!isNaN($(this).val()) && $(this).val().length != 0) {
                    sum += parseInt($(this).val());
                };
            });

            return sum;
        };

        function LoadTaskCategoryOptions() {
            if (categoriesOptions == '') {
                $.each($.parseJSON('<%=GetListTaskCategory()%>'), function (key, value) {
                    categoriesOptions += "<option value=\"" + key + "\">" + value + "</option>"
                });

                if ($('.category-list option[value="new"]').length) {
                    categoriesOptions += "<option value='new'>< New ></option>";
                };
            };

            return categoriesOptions;
        };

        function ShowDocument(url) {
            var win = window.open(url, '_blank');
        }

        function Redirect(id, push) {
            if (id == 1) {
                if (push == 1) {
                    window.location.href('../dashjs/dashboardjsNew.aspx?pushchart=1');
                }
                else {
                    window.location.href('../dashjs/dashboardjsNew.aspx');
                }
                return false;
            }
        }

        function GoToDash() {
            $("#GenericComingSoon").modal('show');
            $("#CreateSuccess").modal('hide');
            var url = "../dashjs/dashboardjsNew.aspx";
            $(location).attr('href', url);
        };

        function ReloadPage() {
            $("#GenericComingSoon").modal('show');
            window.location.href = 'adddtask.aspx';
        };

        function RedirectFromCancelButton() {
            if (ShowTChart == true) {
                Redirect(1, 1);
            }
            else {
                Redirect(1, 0);
            }
        }

        function ShowVideoList(TaskID) {
            $("#GenericComingSoon").modal('show');
        }

        function ShowGenericComingSoon() {
            try {
                $("#GenericComingSoon").modal('show');
            }
            catch (ex) {
            };
        }

        function DismissGenericComingSoon() {
            try {
                $("#GenericComingSoon").modal('hide');
            }
            catch (ex) {
            };
        };

        function CreateSuccess(msg) {
            DismissGenericComingSoon();
            $("#TaskCreateStatus").html();
            $("#TaskCreateStatus").html(msg);
            $("#CreateSuccess").modal('show');
        }

        function DismissCreateSuccess() {
            $("#TaskCreateStatus").html();
            $("#CreateSuccess").modal('hide');
            if ($("#TaskID").val() != "") {
                var url = "../dashjs/adddtask.aspx?TaskID=" + $("#TaskID").val();
            }
            else if ($("#TemplateTaskID").val() != "") {
                var url = "../dashjs/adddtask.aspx?TemplateTaskID=" + $("#TemplateTaskID").val();
            }
            $(location).attr('href', url);
        }

        function ValidationError(msg) {
            DismissGenericComingSoon();
            $("#ValidationMessage").html(msg);
            $("#ValidationError").modal('show');
        }

        function DismissValidationError() {
            $("#ValidationError").modal('hide');
        }

        function TriggerAttachmentForSubTask(e) {
            ShowModal($(e).attr("data-index"));
        };

        function TemplateTaskDetail(taskID) {
            $("#GenericComingSoon").modal('show');

            var url = "../dashjs/AdddTask.aspx?TemplateTaskID=" + taskID;
            $(location).attr('href', url);
        };
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="modals" runat="server">
    <asp:HiddenField ID="TaskAdded" runat="server" />

    <div class="modal hide fade" id="BoxAuthModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-content">
                    <div class="modal-header">
                    </div>
                    <div class="modal-body">
                        <iframe id="BoxAuthIFrame" src="" style="display: inherit; height: 500px; width: 600px" runat="server"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <uc:CategoryAndSubcategoryModal runat="server" ID="CategoryAndSubcategoryModal1"></uc:CategoryAndSubcategoryModal>

    <uc:ReferenceMaterialEditonModal runat="server"></uc:ReferenceMaterialEditonModal>

    <uc:UsersGroupModal runat="server" ID="UsersGroupModal"></uc:UsersGroupModal>

    <div id="AddSubtaskModal" class="modal fade bs-modal-lg" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Action Item</h2>
                </div>
                <div class="modal-body">
                    <div class="alert alert-error" style="display: none;">
                    </div>
                    <div class="form">
                        <div class="form-body">
                            <h3 class="form-section subtask-modal-content assign-modal-content">Assignment Information</h3>
                            <div class="row subtask-modal-content assign-modal-content">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Assign To</label>
                                        <div class="col-md-9 assign-to">
                                            <uc:UsersGroup runat="server" ID="AssignToActionItem" />
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Assigned By</label>
                                        <div class="col-md-9">
                                            <select runat="server" id="AssignedByActionItem" class="assigner form-control" multiple="false"></select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row subtask-modal-content assign-modal-content">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Viewers</label>
                                        <div class="col-md-9 viewers">
                                            <uc:UsersGroup runat="server" ID="TaskViewerActionItem" />
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Backup Owners</label>
                                        <div class="col-md-9 backup-owners">
                                            <uc:UsersGroup runat="server" ID="BackupOwnersActionItem" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row subtask-modal-content assign-modal-content approver-content">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Approver</label>
                                        <div class="col-md-9">
                                            <select runat="server" id="ApproverActionItem" class="approver form-control"></select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <h3 class="form-section subtask-modal-content">General Information</h3>

                            <div class="row subtask-modal-content margin-bottom-20">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Name</label>
                                        <div class="col-md-9">
                                            <input type="hidden" class="ActionItemTaskID" />
                                            <asp:TextBox CssClass="validate[required] taskname form-control" ID="ActionItemName" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Description</label>
                                        <div class="col-md-9">
                                            <asp:TextBox ID="ActionItemDescription" CssClass="taskdescription form-control" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <uc:CategoryAndSubcategory runat="server" ID="actionItemCategoryAndSubcategory"></uc:CategoryAndSubcategory>

                            <div class="row margin-top-20 assign-modal-content subtask-modal-content ">
                                <div class="col-md-4">
                                    <label class="control-label col-md-5">Due Date</label>
                                    <div class="col-md-7">
                                        <input type="text" class="text-input datepicker input-small calender form-control" />
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Head's Up days</label>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="headsupActionItem" CssClass="text-input input-xsmall validate[custom[onlyNumber]] headsup form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Urgent days</label>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="UrgentActionItem" CssClass="text-input input-xsmall validate[custom[onlyNumber]] urgent form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a class="btn green" id="add-subtask-template" href="#">Save</a>
                        <a class="btn btn-danger" data-dismiss="modal" href="#">Close</a>
                    </div>
                </div>
            </div>
        </div>

        <uc:YouTubeModalPlayer runat="server" ID="YouTubeModalPlayer"></uc:YouTubeModalPlayer>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 id="PageTitle" runat="server" class="hide-on-content-only page-title">Template Objective
                <small>A standardized objective with SQUEEZE points. It may be assigned, viewed, and actionable by other people</small>
            </h3>

            <div class="page-bar hide-on-content-only">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="templatetasks.aspx">Template Objectives</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Create</a>
                    </li>
                </ul>
            </div>

            <asp:HiddenField ID="TaskID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="TemplateTaskID" runat="server" ClientIDMode="Static" />
            <div class="portlet box green main-form">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-bullseye"></i>
                        <span id="NewEditTemplateTaskTitle" runat="server">New Template Objective</span>
                    </div>
                </div>
                <div class="portlet-body form">
                    <div class="form-body">
                        <h3 class="form-section subtask-modal-content assign-modal-content">Assignment Information</h3>
                        <div class="row subtask-modal-content assign-modal-content">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Assign To</label>
                                    <div class="col-md-9">
                                        <uc:UsersGroup runat="server" ID="Assignee" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Assigned By</label>
                                    <div class="col-md-9">
                                        <select runat="server" id="ListAssignedBy" class="assigner form-control" multiple="false"></select>
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
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Backup Owners</label>
                                    <div class="col-md-9">
                                        <uc:UsersGroup runat="server" ID="TaskBackupOwners" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row subtask-modal-content assign-modal-content approver-content">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Approver</label>
                                    <div class="col-md-9">
                                        <select runat="server" id="ListApprover" class="approver form-control"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <h3 class="form-section subtask-modal-content">General Information</h3>

                        <div class="row subtask-modal-content margin-bottom-20">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Name</label>
                                    <div class="col-md-6">
                                        <asp:TextBox CssClass="validate[required] taskname form-control" ID="TaskName" runat="server"></asp:TextBox>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="checkbox-list">
                                            <label class="withTooltip" data-title="If checked would allow task assigner to change the task name at time of assignment">
                                                <input type="checkbox" name="nameEditable" id="NameEditable" runat="server" />
                                                Name is editable
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Description</label>
                                    <div class="col-md-9">
                                        <asp:TextBox ID="TaskDescription" CssClass="taskdescription form-control" runat="server"></asp:TextBox>
                                    </div>


                                </div>
                            </div>
                        </div>

                        <uc:CategoryAndSubcategory runat="server" ID="CategoryAndSubcategory"></uc:CategoryAndSubcategory>

                        <div class="row">
                            <div class="col-md-6 template-content mark-as-approver-container">
                                <label class="control-label col-md-3">Completion Approval Required</label>
                                <div class="col-md-9">
                                    <input type="checkbox" name="mark-as-approver" id="markForApproval" runat="server" />
                                </div>
                            </div>
                            <div class="col-md-6 approvable-content">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Approval Condition</label>
                                    <div class="col-md-9">
                                        <select runat="server" id="ApprovalConditionSelect" class="form-control" disabled="disabled"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row template-task-content">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Template Approver</label>
                                    <div class="col-md-9">
                                        <select runat="server" id="TemplateTaskApprover" class="form-control"></select>
                                    </div>
                                </div>
                            </div>


                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Archived</label>
                                    <div class="col-md-9" style="margin-top: 8px;">
                                        <input type="checkbox" name="StatusCheckbox" id="StatusCheckbox" runat="server" disabled="disabled" />
                                        <input type="hidden" name="statusId" id="statusId" runat="server" />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 template-content mark-as-approver-container">
                                <label class="control-label col-md-3">Assignable</label>
                                <div class="col-md-9" style="margin-top: 9px;">
                                    <input type="checkbox" name="mark-as-assignable" id="assignableCheckbox" runat="server" class="withTooltip" title="Checking Assignable will allow the Template Objective to be assigned by any user. These items will be listed under 'Opportunities' on the dashboard."/>
                                </div>
                            </div>
                        </div>

                        <div class="row margin-top-20 assign-modal-content subtask-modal-content ">
                            <div class="col-md-4">
                                <label class="control-label col-md-5">Due Date</label>
                                <div class="col-md-7">
                                    <input type="text" id="datepicker" runat="server" class="text-input datepicker input-small calender form-control" />
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label col-md-6">Head's Up days</label>
                                <div class="col-md-6">
                                    <asp:TextBox ID="HeadsUp" CssClass="text-input input-xsmall validate[custom[onlyNumber]] headsup form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label col-md-6">Urgent days</label>
                                <div class="col-md-6">
                                    <asp:TextBox ID="Urgent" CssClass="text-input input-xsmall validate[custom[onlyNumber]] urgent form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <asp:PlaceHolder runat="server" ID="PointsPanel">
                            <h3 class="form-section subtask-modal-content">SQUEEZE Points</h3>
                            <div class="row subtask-modal-content score-container">
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Safety (S)</label>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtSafety" CssClass="validate[custom[onlyNumber]] score txtSafety input-xsmall form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Quality (QU)</label>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtQuality" CssClass="validate[custom[onlyNumber]] score txtQuality input-xsmall form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Effectiveness (E)</label>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtEffectiveness" CssClass="validate[custom[onlyNumber]] score txtEffectiveness input-xsmall form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row subtask-modal-content score-container">
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Efficiency (E)</label>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtEfficienc" CssClass="validate[custom[onlyNumber]] score txtEfficienc input-xsmall form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Zest (ZE)</label>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtZest" CssClass="validate[custom[onlyNumber]] score txtZest input-xsmall form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row subtask-modal-content score-container">
                                <div class="col-md-4">
                                    <label class="control-label col-md-6">Total</label>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtSum" CssClass="validate[custom[onlyNumber]] txtSum input-xsmall form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </asp:PlaceHolder>

                        <h3 class="form-section">Action Items</h3>

                        <div class="row">
                            <div class="col-md-12">
                                <uc:SubTaskTable runat="server" ID="SubTaskTable"></uc:SubTaskTable>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <a href="#" class="btn green" onclick="ShowSubTaskModal();return false;">
                                    <i class="fa fa-plus"></i>
                                </a>
                            </div>
                        </div>

                        <h3 class="form-section">Reference Materials</h3>
                        <div class="row">
                            <div class="col-md-12">
                                <asp:PlaceHolder ID="phUserControl" runat="server"></asp:PlaceHolder>
                            </div>
                        </div>
                        <%--<div class="row">
                            <div class="col-md-12">
                                <asp:CheckBoxList ID="TaskOptions" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                    <asp:ListItem Enabled="false" Selected="True" Text="Add to Transparency Chart"></asp:ListItem>
                                    <asp:ListItem Text="Add to Calendar"></asp:ListItem>
                                </asp:CheckBoxList>
                            </div>
                        </div>--%>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="UpdateTask" runat="server" Text="Assign Objective" CommandName="0" OnClick="SaveTask_Click" CssClass="btn green" />
                        <asp:Button ID="SaveTaskAsTemplate" runat="server" CommandName="1" Text="Save as Template" OnClick="SaveTask_Click" CssClass="btn green" />
                        <asp:Button ID="SaveAsNew" Visible="false" runat="server" CommandName="1" Text="Submit for Approval as New" OnClick="SaveAsNew_Click" CssClass="btn green hide-on-content-only" />
                        <asp:Button ID="SaveTaskAsTemplateAndAssign" runat="server" CommandName="2" Text="Save as Template & Assign" OnClick="SaveTask_Click" CssClass="btn green" />
                        <input type="button" id="CancelTaskbtn" class="btn" value="Cancel" />
                    </div>

                </div>
            </div>
        </div>
        <asp:HiddenField ID="hfSubTaskCount" runat="server" />
    </div>
</asp:Content>
