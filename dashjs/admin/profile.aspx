<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="profile.aspx.cs" Inherits="ManageUPPRM.profile" EnableEventValidation="false" EnableViewStateMac="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <title>Admin</title>
    <script src="../../admin/admin.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-content-wrapper">
        <div class="page-content">
            <div>
                <div>
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
                                    <asp:HiddenField ID="UserID" runat="server" />

                                    <div class="portlet box grey-silver">
                                        <div class="portlet-title">
                                            <div class="caption" id="FullName" runat="server"></div>
                                        </div>
                                        <div class="portlet-body">
                                            <div class="form">
                                                <div class="form-horizontal">
                                                    <div class="form-body">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="form">
                                                                    <div class="form-body">
                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="lname">Title</label>
                                                                            <div class="col-md-9">
                                                                                <input id="Title" name="lname" type="text" placeholder="" class="form-control" runat="server" readonly="readonly" />
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="fname">First Name</label>
                                                                            <div class="col-md-9">
                                                                                <input id="fname" name="fname" type="text" placeholder="" class="form-control" runat="server" readonly="readonly" />
                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="fname" ErrorMessage="First Name is required" Enabled="false"></asp:RequiredFieldValidator>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="lname">Last Name</label>
                                                                            <div class="col-md-9">
                                                                                <input id="lname" name="lname" type="text" placeholder="" class="form-control" runat="server" readonly="readonly" />
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="">Email</label>
                                                                            <div class="col-md-9">
                                                                                <asp:TextBox ID="email" runat="server" CssClass="form-control" ReadOnly="true" />
                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="email" Display="Dynamic" ErrorMessage="Email is required" Enabled="False"></asp:RequiredFieldValidator>
                                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="email" Display="Dynamic" ErrorMessage="Email not in correct format" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Enabled="false"></asp:RegularExpressionValidator>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="lname">Telephone</label>
                                                                            <div class="col-md-9">
                                                                                <input id="telephone" name="lname" type="text" placeholder="" class="form-control" runat="server" readonly="readonly" />
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="lname">Department</label>
                                                                            <div class="col-md-9">
                                                                                <p id="Dept" runat="server" class="form-control-static"></p>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="lname">Address Line 1</label>
                                                                            <div class="col-md-9">
                                                                                <input id="add1" name="lname" type="text" placeholder="" class="form-control" runat="server" readonly="readonly" />
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="lname">Address Line 2</label>
                                                                            <div class="col-md-9">
                                                                                <input id="add2" name="lname" type="text" placeholder="" class="form-control" runat="server" readonly="readonly" />
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="lname">City</label>
                                                                            <div class="col-md-9">
                                                                                <input id="city" name="lname" type="text" placeholder="" class="form-control" runat="server" readonly="readonly">
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="lname">State</label>
                                                                            <div class="col-md-9">
                                                                                <asp:DropDownList ID="USState" runat="server" CssClass="form-control" AppendDataBoundItems="true" Enabled="false">
                                                                                    <asp:ListItem Text="Select" Value="0" />
                                                                                </asp:DropDownList>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Text input-->
                                                                        <div class="form-group">
                                                                            <label class="control-label col-md-3" for="lname">Zip Code</label>
                                                                            <div class="col-md-9">
                                                                                <input id="zip" name="lname" type="text" placeholder="" class="form-control" runat="server" readonly="readonly">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <!-- Select Basic -->
                                                                <div class="form-group">
                                                                    <label class="control-label col-md-3">Last Login</label>
                                                                    <div class="col-md-9">
                                                                        <asp:Label ID="LastLogin" runat="server" CssClass="form-control-static"></asp:Label>
                                                                    </div>
                                                                </div>

                                                                <!-- Select Basic -->
                                                                <div class="form-group">
                                                                    <label class="control-label col-md-3">Active</label>
                                                                    <div class="col-md-9">
                                                                        <p id="Status" runat="server" class="form-control-static"></p>
                                                                    </div>
                                                                </div>

                                                                <!-- Select Basic -->
                                                                <div class="form-group">
                                                                    <label class="control-label col-md-3" for="systemrole">System Role</label>
                                                                    <div class="col-md-9">
                                                                        <p id="systemrole" runat="server" class="form-control-static"></p>
                                                                    </div>
                                                                </div>

                                                                <!-- Text input-->
                                                                <div class="form-group">
                                                                    <label class="control-label col-md-3">New Password</label>
                                                                    <div class="col-md-9">
                                                                        <asp:TextBox ID="pwd1" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
                                                                        <asp:RegularExpressionValidator ID="Regex3" runat="server" Display="Dynamic" ControlToValidate="pwd1" ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z@#$!%^&*()\\=_+\d]{8,}$" ErrorMessage="Password must contain: Minimum of 8 characters, at least one uppercase letter, one lowercase letter and one number" ForeColor="Red" />

                                                                    </div>
                                                                </div>

                                                                <!-- Text input-->
                                                                <div class="form-group">
                                                                    <label class="control-label col-md-3" for="">Re-enter New Password</label>
                                                                    <div class="col-md-9">
                                                                        <asp:TextBox ID="pwd2" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
                                                                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToCompare="pwd1" ControlToValidate="pwd2" ErrorMessage="Password do not match" ForeColor="Red"></asp:CompareValidator>
                                                                    </div>
                                                                </div>




                                                                <div class="form-group">
                                                                    <div class="col-md-12">
                                                                        <img class="img-circle" src="<%=GetProfileImage() %>" onerror="loadDefaultImage(this);" style="max-width: 250px; max-height: 250px" />
                                                                    </div>
                                                                    <div class="col-md-12" style="padding-top: 10px;">
                                                                        <asp:FileUpload ID="ProfileUploader" runat="server" />
                                                                        <asp:Button ID="ButtonUpload" runat="server" Text="Update" OnClick="ButtonUpload_Click" CssClass="btn btn-success" Visible="False" />
                                                                    </div>
                                                                </div>


                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-actions">
                                                        <div class="row">
                                                            <div class="col-md-12">
                                                                <asp:Button ID="UpdateUser" runat="server" OnClientClick="ShowWIP();" OnClick="UpdateUser_Click" CssClass="btn green" Text="Save" />
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
        </div>
    </div>
</asp:Content>
<asp:Content ContentPlaceHolderID="modals" ID="Content3" runat="server">
    <div id="WorkingModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="windowTitleLabel" aria-hidden="true">
        <div class="modal-header">
            <h3>Working...&nbsp<img src="../img/ajax-loader.gif" /></h3>
        </div>
        <div class="modal-footer">
        </div>
    </div>

    <div id="GenericMessage" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body">
            <h2 id="GenericMessageHeader"></h2>
        </div>
        <div class="modal-footer">
            <button class="btn btn-success" data-dismiss="modal" aria-hidden="true">Close</button>
        </div>
    </div>

</asp:Content>
