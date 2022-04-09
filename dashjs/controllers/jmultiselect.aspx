<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="jmultiselect.aspx.cs" Inherits="ManageUPPRM.dashjs.controllers.jmultiselect" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../../Scripts/jquery-2.1.0.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../Content/bootstrap-modal.js"></script>
    <script src="../Content/bootstrap-tab.js"></script>

    <script src="../js/bootstrap-multiselect.js"></script>

    <link href="../css/bootstrap.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/bootstrap-multiselect.css" type="text/css" />

    <script type="text/javascript">
        $(document).ready(function () {
            $('.multiselect').multiselect();
        });
    </script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <select class="multiselect" multiple="multiple">
                <option value="cheese">Cheese</option>
                <option value="tomatoes">Tomatoes</option>
                <option value="mozarella">Mozzarella</option>
                <option value="mushrooms">Mushrooms</option>
                <option value="pepperoni">Pepperoni</option>
                <option value="onions">Onions</option>
            </select>
        </div>
    </form>
</body>
</html>