var currentContainer,
    newVal = 'new';

var initializeCategoryAndSubcategory = function (container) {
    var categories = container.find('select.category-list'),
        subcategories = container.find('select.subcategory-list'),
        selectedSubcategory = subcategories.val(),
        module = {},
        activeModals;

    categories.on('change', function () {
        currentContainer = $(this).closest('.row');
        var selectedValue = categories.val();

        if (selectedValue != newVal) {
            $.ajax({
                type: "POST",
                url: window.location.protocol + "//" + window.location.host + "/ManageUPWebService.asmx/GetTaskSubCategory",
                data: JSON.stringify({ parentCategory: selectedValue }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                },
                success: function (data) {
                    var subCategoriesOptions;
                    var addNew = categories.find('option[value="' + newVal + '"]').length > 0;
                    $.each(data.d, function (i, el) {
                        subCategoriesOptions += "<option value='" + el.Value + "' >" + el.Text + "</option> \r\n";
                    });

                    subcategories.find('option').remove();
                    if (addNew) {
                        subCategoriesOptions += "<option value='" + newVal + "' >< New ></option> \r\n";
                    };

                    subcategories.html(subCategoriesOptions).val(selectedSubcategory != newVal ? selectedSubcategory : '');
                    subcategories.val('').trigger('change');
                }
            });
        }
        else {
            categories.val('');
            subcategories.find('option').remove();
            activeModals = $('.modal:visible');

            var addCategoryModal = $('#AddCategoryModal');
            activeModals.each(function (i, el) {
                $(el).modal('hide');
            });

            addCategoryModal.off('hidden');
            addCategoryModal.on('hidden', function () {
                activeModals.each(function (i, el) {
                    $(el).modal('show');
                });
            });

            addCategoryModal.modal('show');
        };
    });

    subcategories.on('change', function () {
        currentContainer = $(this).closest('.row');
        selectedSubcategory = subcategories.val() == '' ? selectedSubcategory : subcategories.val();

        if (subcategories.val() != selectedSubcategory && subcategories.find('option[value="' + selectedSubcategory + '"]').length) {
            subcategories.val(selectedSubcategory);
        };

        if (selectedSubcategory == newVal) {
            var categoryValue = categories.val(),
                subcategoryModal = $('#AddSubcategoryModal');

            activeModals = $('.modal:visible');

            subcategoryModal.find('input[name="categortyId"]').val(categoryValue);
            selectedSubcategory = '';
            subcategories.val(selectedSubcategory);

            activeModals.each(function (i, el) {
                $(el).modal('hide');
            });

            subcategoryModal.off('hidden');
            subcategoryModal.on('hidden', function () {
                activeModals.each(function (i, el) {
                    $(el).modal('show');
                });
            });

            subcategoryModal.modal('show');
        };
    });

    module.setSelectedSubCategory = function (subcategory) {
        selectedSubcategory = subcategory;
    };

    return module;
};

$(document).ready(function () {
    var subcategoryModal = $('#AddSubcategoryModal'),
        categoryModal = $('#AddCategoryModal');

    categoryModal.find('#save-category').on('click', function () {
        var name = categoryModal.find('input[name="name"]').val();

        $.ajax({
            type: "POST",
            url: resolveHost() + "/ManageUPWebService.asmx/AddCategory",
            data: JSON.stringify({ name: name }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
            },
            success: function (result) {
                if (result.d.Success) {
                    $('select.category-list').append("<option value='" + result.d.Data + "' >" + name + "</option>");
                    currentContainer.find('select.category-list').val(result.d.Data).trigger('change');
                    categoryModal.modal('hide');
                }
                else {
                    showErrorMsgs(categoryModal, result.d.Errors);
                };
            }
        });
    });

    subcategoryModal.find('#save-sub-category').on('click', function () {
        var name = subcategoryModal.find('input[name="name"]').val();
        $.ajax({
            type: "POST",
            url: resolveHost() + "/ManageUPWebService.asmx/AddSubCategory",
            data: JSON.stringify({ name: name, categoryID: subcategoryModal.find('input[name="categortyId"]').val() }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
            },
            success: function (result) {
                if (result.d.Success) {
                    $('select.subcategory-list').append("<option value='" + result.d.Data + "' >" + name + "</option>");
                    currentContainer.find('select.subcategory-list').val(result.d.Data).trigger('change')
                    subcategoryModal.modal('hide');
                }
                else {
                    showErrorMsgs(subcategoryModal, result.d.Errors);
                };
            }
        });
    });
});