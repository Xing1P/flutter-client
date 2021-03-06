import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/data/models/client_model.dart';
import 'package:invoiceninja_flutter/data/models/invoice_model.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/ui/app/form_card.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class VariablesHelp extends StatefulWidget {
  const VariablesHelp({this.showEmailVariables = false});

  final bool showEmailVariables;

  @override
  _VariablesHelpState createState() => _VariablesHelpState();
}

class _VariablesHelpState extends State<VariablesHelp>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(vsync: this, length: widget.showEmailVariables ? 6 : 5);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final company = state.company;

    return FormCard(
      children: [
        TabBar(
          controller: _controller,
          isScrollable: true,
          tabs: [
            Tab(child: Text(localization.invoice)),
            Tab(child: Text(localization.client)),
            Tab(child: Text(localization.contact)),
            Tab(child: Text(localization.company)),
            Tab(child: Text(localization.user)),
            if (widget.showEmailVariables) Tab(child: Text(localization.email)),
          ],
        ),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _controller,
            children: [
              _VariableGrid(
                fields: [
                  'view_link', // TODO change to email variables
                  'view_url',
                  InvoiceFields.amount,
                  InvoiceFields.discount,
                  InvoiceFields.balance,
                  InvoiceFields.date,
                  InvoiceFields.dueDate,
                  InvoiceFields.poNumber,
                  InvoiceFields.publicNotes,
                  InvoiceFields.exchangeRate,
                  InvoiceFields.number,
                  InvoiceFields.terms,
                  InvoiceFields.footer,
                  if (company.hasCustomField(CustomFieldType.invoice1))
                    InvoiceFields.customValue1,
                  if (company.hasCustomField(CustomFieldType.invoice2))
                    InvoiceFields.customValue2,
                  if (company.hasCustomField(CustomFieldType.invoice3))
                    InvoiceFields.customValue3,
                  if (company.hasCustomField(CustomFieldType.invoice4))
                    InvoiceFields.customValue4,
                  if (company.hasCustomField(CustomFieldType.surcharge1))
                    InvoiceFields.customSurcharge1,
                  if (company.hasCustomField(CustomFieldType.surcharge2))
                    InvoiceFields.customSurcharge2,
                  if (company.hasCustomField(CustomFieldType.surcharge3))
                    InvoiceFields.customSurcharge3,
                  if (company.hasCustomField(CustomFieldType.surcharge4))
                    InvoiceFields.customSurcharge4,
                ],
              ),
              _VariableGrid(
                fields: [
                  ClientFields.name,
                  ClientFields.publicNotes,
                  ClientFields.vatNumber,
                  ClientFields.address1,
                  ClientFields.address2,
                  ClientFields.city,
                  ClientFields.state,
                  ClientFields.postalCode,
                  ClientFields.country,
                  ClientFields.shippingAddress1,
                  ClientFields.shippingAddress2,
                  ClientFields.shippingCity,
                  ClientFields.shippingState,
                  ClientFields.shippingPostalCode,
                  ClientFields.shippingCountry,
                  ClientFields.phone,
                  ClientFields.creditBalance,
                  ClientFields.idNumber,
                  if (company.hasCustomField(CustomFieldType.client1))
                    ClientFields.custom1,
                  if (company.hasCustomField(CustomFieldType.client2))
                    ClientFields.custom2,
                  if (company.hasCustomField(CustomFieldType.client3))
                    ClientFields.custom3,
                  if (company.hasCustomField(CustomFieldType.client4))
                    ClientFields.custom4,
                ].map((field) => 'client.$field').toList(),
              ),
              _VariableGrid(
                fields: [
                  ContactFields.firstName,
                  ContactFields.lastName,
                  ContactFields.email,
                  ContactFields.phone,
                  if (company.hasCustomField(CustomFieldType.contact1))
                    ContactFields.custom1,
                  if (company.hasCustomField(CustomFieldType.contact2))
                    ContactFields.custom2,
                  if (company.hasCustomField(CustomFieldType.contact3))
                    ContactFields.custom3,
                  if (company.hasCustomField(CustomFieldType.contact4))
                    ContactFields.custom4,
                ].map((field) => 'contact.$field').toList(),
              ),
              _VariableGrid(
                fields: [
                  CompanyFields.name,
                  CompanyFields.country,
                  CompanyFields.address1,
                  CompanyFields.address2,
                  CompanyFields.idNumber,
                  CompanyFields.email,
                  CompanyFields.phone,
                  CompanyFields.state,
                  CompanyFields.vatNumber,
                  CompanyFields.website,
                  if (company.hasCustomField(CustomFieldType.company1))
                    CompanyFields.custom1,
                  if (company.hasCustomField(CustomFieldType.company2))
                    CompanyFields.custom2,
                  if (company.hasCustomField(CustomFieldType.company3))
                    CompanyFields.custom3,
                  if (company.hasCustomField(CustomFieldType.company4))
                    CompanyFields.custom4,
                ].map((field) => 'company.$field').toList(),
              ),
              _VariableGrid(
                fields: [
                  UserFields.firstName,
                  UserFields.lastName,
                  UserFields.phone,
                  UserFields.email,
                  if (company.hasCustomField(CustomFieldType.user1))
                    UserFields.custom1,
                  if (company.hasCustomField(CustomFieldType.user2))
                    UserFields.custom2,
                  if (company.hasCustomField(CustomFieldType.user3))
                    UserFields.custom3,
                  if (company.hasCustomField(CustomFieldType.user4))
                    UserFields.custom4,
                ].map((field) => 'user.$field').toList(),
              ),
              if (widget.showEmailVariables) SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

class _VariableGrid extends StatelessWidget {
  const _VariableGrid({this.fields});

  final List<String> fields;

  @override
  Widget build(BuildContext context) {
    fields.sort((a, b) => a.compareTo(b));

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(6),
          shrinkWrap: true,
          primary: true,
          crossAxisCount: 3,
          childAspectRatio: 3 / 1,
          children: fields.map((field) => SelectableText('\$$field')).toList()),
    );
  }
}
