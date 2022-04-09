<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="settings.aspx.cs" Inherits="ManageUPPRM.settings" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Admin</title>

    <script type="text/javascript">
        $(document).ready(function () {
            var successMsg = $('#successMsg').val(),
                errorMsg = $('#errorMsg').val();

            if (successMsg) {
                showSuccessMsg(successMsg);
            };

            if (errorMsg) {
                showErrorMsg(errorMsg);
            };

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
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField runat="server" ID="errorMsg" />
    <asp:HiddenField runat="server" ID="successMsg" />
    <div class="page-content-wrapper">
        <div class="page-content">
            <!-- Only required for left/right tabs -->
            <div class="portlet light bordered" data-team="false">
                <div class="portlet-title " style="border: none;">
                    <div class="tabbable-line col-md-9">
                        <ul class="nav nav-tabs home-tabs nav-justified task-widget" id="AdminTabs">
                            <asp:Literal ID="AdminMenu" runat="server" />
                        </ul>
                    </div>
                </div>
            </div>
            <div class="tab-content">
                <div class="tab-pane active" id="tab0">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="portlet box grey-silver">
                                <div class="portlet-title">
                                    <div class="caption">
                                        Site Settings
                                    </div>
                                </div>
                                <div class="portlet-body">
                                    <div class="form main-form">
                                        <div class="form-horizontal">
                                            <div class="form-body">
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <div class="form">
                                                            <div class="form-group">
                                                                <label class="control-label col-md-3 withTooltip" title="Number of points in each SQUEEZE container that must be completed before receiving a star" for="squeeze">SQUEEZE Threshold</label>
                                                                <div class="col-md-9">
                                                                    <input id="squeeze" runat="server" name="squeeze" type="text" placeholder="" class="form-control input-xsmall" />
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="control-label col-md-3 withTooltip" data-original-title="Number of days Objectives remain on the Transparency Chart after completion; All Objectives can be accessed through Objectives tab." for="squeeze">Number of days after completion</label>
                                                                <div class="col-md-9">
                                                                    <input id="txtTaskDaysAfterCompletion" runat="server" name="squeeze" type="text" placeholder="" class="form-control input-xsmall" />
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="control-label col-md-3" for="emailLink">Email Link</label>
                                                                <div class="col-md-9">
                                                                    <input id="emailLink" runat="server" name="emailLink" type="text" placeholder="" class="form-control validate[custom[url]]" />
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="control-label col-md-3" for="websiteLink">Website Link</label>
                                                                <div class="col-md-9">
                                                                    <input id="websiteLink" runat="server" name="websiteLink" type="text" placeholder="" class="form-control validate[custom[url]]" />
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="control-label col-md-3" for="Trusted Domain">Trusted Domain</label>
                                                                <div class="col-md-9">
                                                                    <input id="TrustedDomain" placeholder="yourdomain.com" runat="server" name="TrustedDomain" type="text" class="form-control validate[custom[domain]]" />
                                                                </div>
                                                            </div>

                                                            <div class="form-group">
                                                                <label class="control-label col-md-3" for="websiteLink">Users can configure notifications</label>
                                                                <div class="col-md-1 withTooltip" data-original-title="Allow users to customize their own notifications settings. Otherwise the global configuration will be used instead.">
                                                                    <asp:CheckBox ID="chkNotifications" runat="server" CssClass="form-control" />
                                                                </div>
                                                                <div class="col-md-1">
                                                                    <a href="/dashjs/admin/notifications.aspx#portlet_global_tab" class="btn btn-blue" style="margin-top: 4px;" target="_blank">
                                                                        <i class="fa fa-external-link"></i>
                                                                        &nbsp;
                                                                        Global Notifications Configuration
                                                                    </a>
                                                                </div>
                                                            </div>
                                                            
                                                            <div class="form-group">
                                                                <label class="control-label col-md-3" for="MaximumPasswordAge">Maximum Password Age</label>
                                                                <div class="col-md-9">
                                                                    <input id="MaximumPasswordAge" runat="server" data-original-title="The 'Maximum Password Age' determines the period of time (in days) that a password can be used before the system requires the user to change it. Leave blank if you don't want passwords to expire." name="MaximumPasswordAge" type="text" placeholder="" class="form-control input-xsmall withTooltip validate[integer]" />
                                                                </div>
                                                            </div>

                                                            <h4 class="form-section">Client Logos</h4>

                                                            <div class="form-group">
                                                                <label class="control-label col-md-3 withTooltip" for="headerlogo" title="The height will be set to 90px">Header Logo</label>
                                                                <div class="col-md-9">
                                                                    <asp:Image ID="HeaderLogo" runat="server" Height="90px" BackColor="#354455" CssClass="margin-bottom-10" />
                                                                    <asp:FileUpload ID="HeaderLogoFileUploader" runat="server" />
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="control-label col-md-3 withTooltip" for="websiteLink" title="The height will be set to 90px">Report Logo</label>
                                                                <div class="col-md-9">
                                                                    <asp:Image ID="ReportLogo" runat="server" Height="90px" CssClass="margin-bottom-10" />
                                                                    <asp:FileUpload ID="ReportLogoFileUploader" runat="server" />
                                                                </div>
                                                            </div>

                                                            <h4 class="form-section tooltips" data-placement="left" data-original-title="Allows Client Admin to add a relevant link to the Integration Bar on the Dashboard. This is accessible to all users.">Configurable Link</h4>
                                                            <div class="form-group">
                                                                <label class="control-label col-md-2" for="linkName">Name</label>
                                                                <div class="col-md-4">
                                                                    <input id="linkName" runat="server" name="linkName" type="text" placeholder="" class="form-control" />
                                                                </div>
                                                                <label class="control-label col-md-2" for="linkURL">URL</label>
                                                                <div class="col-md-4">
                                                                    <input id="linkURL" runat="server" name="linkURL" type="text" placeholder="" class="form-control validate[custom[url]]" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-actions">
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <asp:Button ID="UpdateSettings" runat="server" OnClick="UpdateSettings_Click" CssClass="btn green" Text="Save" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
