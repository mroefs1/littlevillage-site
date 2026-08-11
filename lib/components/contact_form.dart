import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';
import '../constants/turnstile.dart';

enum _SubmitStatus { idle, submitting, success, error }

// Matches the exact string functions/api/contact.js returns for a missing/
// invalid requestType, so a 400 with this message (the disabled-button UX
// bypassed somehow) can be pinned to the dropdown specifically instead of
// showing a generic error.
const _requestTypeRequiredMessage = 'Please select General Inquiry or Schedule a Tour.';

const _dangerColor = Color('#b3261e');

// The one interactive (@client) piece of the Contact page - everything else
// (title, info column) stays static. Fields are uncontrolled (read via
// GlobalNodeKey at submit time) rather than tracked in state, since a
// controlled textarea/input re-render on every keystroke risks cursor-jump
// bugs for no benefit here. `requestType` is the exception: it drives the
// submit button's disabled state, so it has to live in State.
@client
class ContactForm extends StatefulComponent {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();

  @css
  static List<StyleRule> get styles => [
    css('.contact-form-grid .cf-turnstile').styles(
      margin: .only(top: 4.px),
      gridPlacement: GridPlacement(columnStart: LinePlacement.span(2)),
    ),
    css('.contact-btn-primary').styles(display: .flex, justifyContent: .center, alignItems: .center, gap: .all(8.px)),
    css('.contact-btn-primary:disabled').styles(
      opacity: 0.55,
      raw: {'cursor': 'not-allowed'},
    ),
    css.keyframes('contact-spin', {
      'from': Styles(transform: .rotate(0.deg)),
      'to': Styles(transform: .rotate(360.deg)),
    }),
    css('.contact-spinner').styles(
      display: .inlineBlock,
      width: 14.px,
      height: 14.px,
      border: .all(color: Colors.white, width: 2.px),
      radius: .all(.circular(50.percent)),
      animation: Animation(name: 'contact-spin', duration: 700.ms, curve: .linear),
      raw: {'border-top-color': 'transparent', 'animation-iteration-count': 'infinite'},
    ),
    css('.contact-honeypot').styles(
      position: .absolute(left: (-9999).px),
      width: 1.px,
      height: 1.px,
      overflow: .hidden,
    ),
    css('.contact-required-mark').styles(color: _dangerColor, fontWeight: .w700),
    css('.contact-required-sr').styles(
      position: .absolute(),
      width: 1.px,
      height: 1.px,
      padding: .zero,
      margin: .all((-1).px),
      overflow: .hidden,
      raw: {'clip': 'rect(0, 0, 0, 0)', 'white-space': 'nowrap'},
    ),
    css('.contact-field-hint').styles(
      margin: .only(top: (-4).px),
      color: AppColors.body,
      fontSize: 12.px,
    ),
    css('.contact-field select[aria-invalid="true"], .contact-field input[aria-invalid="true"]').styles(
      border: .all(color: _dangerColor, width: 1.5.px),
    ),
    css('.contact-form-feedback').styles(
      margin: .only(top: 4.px),
      gridPlacement: GridPlacement(columnStart: LinePlacement.span(2)),
      color: _dangerColor,
      fontSize: 13.px,
    ),
    css('.contact-form-success').styles(
      padding: .symmetric(vertical: 20.px),
      color: AppColors.ink,
      fontSize: 15.px,
      lineHeight: 1.5.em,
    ),
  ];
}

class _ContactFormState extends State<ContactForm> {
  String? _requestType;
  _SubmitStatus _status = _SubmitStatus.idle;
  String? _feedback;

  final _nameKey = GlobalNodeKey<web.HTMLInputElement>();
  final _dobKey = GlobalNodeKey<web.HTMLInputElement>();
  final _countyKey = GlobalNodeKey<web.HTMLInputElement>();
  final _phoneKey = GlobalNodeKey<web.HTMLInputElement>();
  final _emailKey = GlobalNodeKey<web.HTMLInputElement>();
  final _messageKey = GlobalNodeKey<web.HTMLTextAreaElement>();
  final _honeypotKey = GlobalNodeKey<web.HTMLInputElement>();
  final _turnstileKey = GlobalNodeKey<web.HTMLDivElement>();
  final _requestTypeKey = GlobalNodeKey<web.HTMLSelectElement>();

  Future<void> _submit() async {
    final name = _nameKey.currentNode?.value.trim() ?? '';
    final message = _messageKey.currentNode?.value.trim() ?? '';
    final phone = _phoneKey.currentNode?.value.trim() ?? '';
    final email = _emailKey.currentNode?.value.trim() ?? '';

    if (_requestType == null) {
      setState(() => _feedback = _requestTypeRequiredMessage);
      _requestTypeKey.currentNode?.focus();
      return;
    }
    if (name.isEmpty) {
      setState(() => _feedback = 'Name is required.');
      return;
    }
    if (message.isEmpty) {
      setState(() => _feedback = 'Message is required.');
      return;
    }
    if (phone.isEmpty && email.isEmpty) {
      setState(() => _feedback = 'Please provide a phone number or email address.');
      return;
    }

    final responseInput =
        _turnstileKey.currentNode?.querySelector('input[name="cf-turnstile-response"]')
            as web.HTMLInputElement?;
    final turnstileToken = responseInput?.value ?? '';

    setState(() {
      _status = _SubmitStatus.submitting;
      _feedback = null;
    });

    try {
      final response = await http.post(
        Uri.parse('/api/contact'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'requestType': _requestType,
          'name': name,
          'childDob': _dobKey.currentNode?.value ?? '',
          'countyDistrict': _countyKey.currentNode?.value.trim() ?? '',
          'phone': phone,
          'email': email,
          'message': message,
          'honeypot': _honeypotKey.currentNode?.value ?? '',
          'turnstileToken': turnstileToken,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) {
        setState(() {
          _status = _SubmitStatus.success;
          _feedback = "Thanks — we'll be in touch soon.";
        });
      } else {
        final error = (data['error'] as String?) ?? 'Something went wrong. Please try again.';
        setState(() {
          _status = _SubmitStatus.error;
          _feedback = error;
        });
        if (error == _requestTypeRequiredMessage) {
          _requestTypeKey.currentNode?.focus();
        }
      }
    } catch (_) {
      setState(() {
        _status = _SubmitStatus.error;
        _feedback = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Component build(BuildContext context) {
    if (_status == _SubmitStatus.success) {
      return div(classes: 'contact-form-success', attributes: {'role': 'status'}, [.text(_feedback!)]);
    }

    final isSubmitting = _status == _SubmitStatus.submitting;
    final isRequestTypeError = _feedback == _requestTypeRequiredMessage;

    return form(classes: 'contact-form-grid', [
      _field(
        'What can we help with?',
        full: true,
        required: true,
        child: select(
          key: _requestTypeKey,
          name: 'requestType',
          required: true,
          onChange: (values) => setState(() => _requestType = values.isEmpty ? null : values.first),
          attributes: {
            if (isRequestTypeError) 'aria-invalid': 'true',
            if (isRequestTypeError) 'aria-describedby': 'contact-form-feedback',
          },
          [
            option(value: '', disabled: true, selected: _requestType == null, [.text('Select one...')]),
            option(value: 'general', selected: _requestType == 'general', [.text('General Inquiry')]),
            option(value: 'tour', selected: _requestType == 'tour', [.text('Schedule a Tour')]),
          ],
        ),
      ),
      _field(
        'Parent / guardian name',
        full: true,
        required: true,
        child: input(key: _nameKey, type: InputType.text, attributes: {'required': 'required'}),
      ),
      _field("Child's date of birth", child: input(key: _dobKey, type: InputType.date)),
      _field('County / school district (if known)', child: input(key: _countyKey, type: InputType.text)),
      _field('Phone', child: input(key: _phoneKey, type: InputType.tel)),
      _field('Email', child: input(key: _emailKey, type: InputType.email)),
      div(classes: 'contact-field-hint contact-field-full', [
        .text('Phone or email required'),
        _requiredMark(),
      ]),
      _field(
        'What would you like us to know?',
        full: true,
        required: true,
        child: textarea(key: _messageKey, rows: 4, required: true, []),
      ),
      div(classes: 'contact-honeypot', attributes: {'aria-hidden': 'true'}, [
        input(
          key: _honeypotKey,
          type: InputType.text,
          name: 'website',
          attributes: {'tabindex': '-1', 'autocomplete': 'off'},
        ),
      ]),
      div(
        key: _turnstileKey,
        classes: 'cf-turnstile',
        attributes: {'data-sitekey': turnstileSiteKey, 'data-action': turnstileAction},
        [],
      ),
      if (_feedback != null)
        div(
          id: 'contact-form-feedback',
          classes: 'contact-form-feedback',
          attributes: {'role': 'alert'},
          [.text(_feedback!)],
        ),
      div(classes: 'contact-form-actions', [
        button(
          type: ButtonType.button,
          classes: 'contact-btn-primary',
          disabled: _requestType == null || isSubmitting,
          onClick: _submit,
          attributes: {'aria-busy': '$isSubmitting'},
          [
            if (isSubmitting) span(classes: 'contact-spinner', attributes: {'aria-hidden': 'true'}, []),
            .text(isSubmitting ? 'Sending…' : 'Send request →'),
          ],
        ),
      ]),
      script(src: 'https://challenges.cloudflare.com/turnstile/v0/api.js', async: true, defer: true),
    ]);
  }

  static Component _field(
    String labelText, {
    required Component child,
    bool full = false,
    bool required = false,
  }) {
    return label(classes: full ? 'contact-field contact-field-full' : 'contact-field', [
      div(classes: 'contact-field-label', [
        .text(labelText),
        if (required) _requiredMark(),
      ]),
      child,
    ]);
  }

  static Component _requiredMark() {
    return .fragment([
      span(classes: 'contact-required-mark', attributes: {'aria-hidden': 'true'}, [.text(' *')]),
      span(classes: 'contact-required-sr', [.text(' (required)')]),
    ]);
  }
}
