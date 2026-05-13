 <!DOCTYPE html>
<html lang="en-US">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=1"/>
        <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
        <meta http-equiv="cache-control" content="no-cache,no-store"/>
        <meta http-equiv="pragma" content="no-cache"/>
        <meta http-equiv="expires" content="-1"/>
        <meta name='mswebdialog-title' content='Connecting to MyOECD Authentication Service'/>

        <title>Home Realm Discovery</title>
        <script type='text/javascript'>
//<![CDATA[
function HRDErrors(){this.invalidSuffix = 'We do not recognize this organizational account. Enter your organizational account again or contact your administrator for more information.';}
//]]>
</script>

<script type='text/javascript'>
//<![CDATA[
// Copyright (c) Microsoft Corporation.  All rights reserved.
function InputUtil(errTextElementID, errDisplayElementID) {

    if (!errTextElementID)  errTextElementID = 'errorText'; 
    if (!errDisplayElementID)  errDisplayElementID = 'error'; 

    this.hasFocus = false;
    this.errLabel = document.getElementById(errTextElementID);
    this.errDisplay = document.getElementById(errDisplayElementID);
};
InputUtil.prototype.canDisplayError = function () {
    return this.errLabel && this.errDisplay;
}
InputUtil.prototype.checkError = function () {
    if (!this.canDisplayError){
        throw new Error ('Error element not present');
    }
    if (this.errLabel && this.errLabel.innerHTML) {
        this.errDisplay.style.display = '';        
        var cause = this.errLabel.getAttribute('for');
        if (cause) {
            var causeNode = document.getElementById(cause);
            if (causeNode && causeNode.value) {
                causeNode.focus();
                this.hasFocus = true;
            }
        }
    }
    else {
        this.errDisplay.style.display = 'none';
    }
};
InputUtil.prototype.setInitialFocus = function (input) {
    if (this.hasFocus) return;
    var node = document.getElementById(input);
    if (node) {
        if ((/^\s*$/).test(node.value)) {
            node.focus();
            this.hasFocus = true;
        }
    }
};
InputUtil.prototype.setError = function (input, errorMsg) {
    if (!this.canDisplayError) {
        throw new Error('Error element not present');
    }
    input.focus();

    if (errorMsg) {
        this.errLabel.innerHTML = errorMsg;
    }
    this.errLabel.setAttribute('for', input.id);
    this.errDisplay.style.display = '';
};
InputUtil.makePlaceholder = function (input) {
    var ua = navigator.userAgent;

    if (ua != null && 
        (ua.match(/MSIE 9.0/) != null || 
         ua.match(/MSIE 8.0/) != null ||
         ua.match(/MSIE 7.0/) != null)) {
        var node = document.getElementById(input);
        if (node) {
            var placeholder = node.getAttribute("placeholder");
            if (placeholder != null && placeholder != '') {
                var label = document.createElement('input');
                label.type = "text";
                label.value = placeholder;
                label.readOnly = true;
                label.style.position = 'absolute';
                label.style.borderColor = 'transparent';
                label.className = node.className + ' hint';
                label.tabIndex = -1;
                label.onfocus = function () { this.nextSibling.focus(); };

                node.style.position = 'relative';
                node.parentNode.style.position = 'relative';
                node.parentNode.insertBefore(label, node);
                node.onkeyup = function () { InputUtil.showHint(this); };
                node.onblur = function () { InputUtil.showHint(this); };
                node.style.background = 'transparent';

                node.setAttribute("placeholder", "");
                InputUtil.showHint(node);
            }
        }
    }
};
InputUtil.focus = function (inputField) {
    var node = document.getElementById(inputField);
    if (node) node.focus();
};
InputUtil.hasClass = function(node, clsName) {
    return node.className.match(new RegExp('(\\s|^)' + clsName + '(\\s|$)'));
};
InputUtil.addClass = function(node, clsName) {
    if (!this.hasClass(node, clsName)) node.className += " " + clsName;
};
InputUtil.removeClass = function(node, clsName) {
    if (this.hasClass(node, clsName)) {
        var reg = new RegExp('(\\s|^)' + clsName + '(\\s|$)');
        node.className = node.className.replace(reg, ' ');
    }
};
InputUtil.showHint = function (node, gotFocus) {
    if (node.value && node.value != '') {
        node.previousSibling.style.display = 'none';
    }
    else {
        node.previousSibling.style.display = '';
    }
};
InputUtil.updatePlaceholder = function (input, placeholderText) {
    var node = document.getElementById(input);
    if (node) {
        var ua = navigator.userAgent;
        if (ua != null &&
            (ua.match(/MSIE 9.0/) != null ||
            ua.match(/MSIE 8.0/) != null ||
            ua.match(/MSIE 7.0/) != null)) {
            var label = node.previousSibling;
            if (label != null) {
                label.value = placeholderText;
            }
        }
        else {
            node.placeholder = placeholderText;
        }
    }
};

//]]>
</script>


        
        <link rel="stylesheet" type="text/css" href="/adfs/portal/css/style.css?id=24B90B3D880E4605966CF1F9325955B2297955B770A59DA316FA84440BC57752" />
    </head>
    <body dir="ltr" class="body">
    <div id="noScript" style="position:static; width:100%; height:100%; z-index:100">
        <h1>JavaScript required</h1>
        <p>JavaScript is required. This web browser does not support JavaScript or JavaScript in this web browser is not enabled.</p>
        <p>To find out if your web browser supports JavaScript or to enable JavaScript, see web browser help.</p>
    </div>
    <script type="text/javascript" language="JavaScript">
         document.getElementById("noScript").style.display = "none";
    </script>
    <div id="fullPage">
        <div id="brandingWrapper" class="float">
            <div id="branding"></div>
        </div>
        <div id="contentWrapper" class="float">
            <div id="content">
                <div id="header">
                    <img class='logoImage' id='companyLogo' src='/adfs/portal/logo/logo.png?id=5B583B74E48B6364ACD4FEF3266D6652A6C04A538F541E42396DE972873C239F' alt='MyOECD Authentication Service'/>
                </div>
                <main>
                    <div id="workArea">
                            <div id="hrdArea">
        <form id="hrd" method="post" autocomplete="off" novalidate="novalidate" action="/adfs/oauth2/authorize/?client_id=96392889-98b4-45a1-937c-38c7b7628bc7&redirect_uri=https%3A%2F%2Fcontact.oecd.org%2Flogin.aspx&response_type=code%20id_token&scope=openid%20profile&state=OpenIdConnect.AuthenticationProperties%3DKKfoQ5NYFHkU9vn_k7uTMMCelpK0vk8IoGn-GUh4XE5EhW9-Xfv0sfRLwZbVSCgjto8y1U1OlmreIayxBiPoQq25fOCBS1wGeGnO49vJR70CL3LPN75x1CX6j8agTIqE8T_-615r7TgtxtaVYc607ai6Y7GT-dLccZjNOyFBWNEDRPeO6_rJdhhugEXcVsyZu0wu3irK-9P42VGfMgraTe-AxNAwbP5iqtcG0N1SyxUxkN-4Y6QpYYisidve7WDd-dJ3IQ&response_mode=form_post&nonce=639101068586574530.YmZmMmVmYWUtN2I0OC00YWFlLThmNjAtODhkYWVhODMyMTZlZmFkYjlkOWEtMmY5YS00MTRjLWFjYjAtOTMyNWY5NDlhOGFj&x-client-SKU=ID_NET451&x-client-ver=5.3.0.0&client-request-id=7252c40e-19e6-4073-f468-00800000007d"> 
   
            <div id="bySelection">
                <div id="openingMessage" class="groupMargin">Sign in with one of these accounts</div> 
            
                <input id="hrdSelection" type="hidden" />
                <div class="idp" tabIndex="1" role="button" aria-label="OECD/IEA/ITF/NEA" onKeyPress="if (event && (event.keyCode == 32 || event.keyCode == 13)) HRD.selection('http://sts.oecd.org/adfs/services/trust');" onclick="HRD.selection('http://sts.oecd.org/adfs/services/trust'); return false;"><img class="largeIcon float" src="/adfs/portal/images/idp/idp.png?id=3EADD3E829A20DF612C7A77960FF811E66E3EE6BAE2C33C9B20E7478BAC87548" alt="OECD/IEA/ITF/NEA"/><div class="idpDescription float"><span class="largeTextNoWrap indentNonCollapsible">OECD/IEA/ITF/NEA</span></div></div><div class="idp" tabIndex="2" role="button" aria-label="MyOECD" onKeyPress="if (event && (event.keyCode == 32 || event.keyCode == 13)) HRD.selection('urn:myoecd');" onclick="HRD.selection('urn:myoecd'); return false;"><img class="largeIcon float" src="/adfs/portal/images/idp/localsts.png?id=A3911892BE04D81EBA5A8E0C74F77099AA1DB05E542FBFCC78C9DF4B0EC0E3A6" alt="MyOECD"/><div class="idpDescription float"><span class="largeTextNoWrap indentNonCollapsible">MyOECD</span></div></div> 
            </div>

             <div id="byEmail" style="display:none">
                <div class="groupMargin">
                   <img tabIndex="3" class="smallIcon float" onKeyPress="if (event && (event.keyCode == 32 || event.keyCode == 13)) HRD.hideEmailInput();" onclick="HRD.hideEmailInput(); return false;" src="data:image/Png;base64,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" alt="back"/>
                   Other organizational account
                </div>

                <div id="emailArea" class="indent">  
 
                    <div id="emailIntroduction" class="groupMargin">
                        If your organization has established a trust relationship with MyOECD Authentication Service, enter your organizational account below.
                    </div>

                    <div id="error" class="fieldMargin error smallText" >
                        <span id="errorText" for="emailInput" aria-live="assertive" role="alert"></span>
                    </div>

                    <div id="emailInputArea">
                        <label id="emailInputLabel" for="emailInput" class="hidden">Email</label>
                        <input id="emailInput" name="Email" type="email" value="" autocomplete="off" class="text fullWidthIndent"
                               spellcheck="false" placeholder="someone@example.com"/>
                    </div>

                    <div id="submissionArea" class="submitMargin">
                        <input class="submit" name="HomeRealmByEmail" type="submit" value="Next"
                            onclick="return HRD.submitEmail()" />
                    </div>
                 </div>
            </div>

         </form>

         <script type="text/javascript" language="JavaScript">
        //<![CDATA[

             function HRD() {
             }

             HRD.emailInput = 'emailInput';
             HRD.emailMismatch = 'errorText';

             HRD.selection = function (option) {
                 var i = document.getElementById('hrdSelection');
                 i.name = "HomeRealmSelection";
                 i.value = option;
                 document.forms['hrd'].submit();
                 return false;
             }

             HRD.showEmailInput = function () {
                 var selection = document.getElementById('bySelection');
                 selection.style.display = 'none';
                 var email = document.getElementById('byEmail');
                 email.style.display = '';
                 var emailInput = document.getElementById('emailInput');
                 emailInput.focus();
             }

             HRD.hideEmailInput = function () {
                 var selection = document.getElementById('bySelection');
                 selection.style.display = '';
                 var email = document.getElementById('byEmail');
                 email.style.display = 'none';
             }

             HRD.initialize = function () {

                 var u = new InputUtil();
                 u.checkError();

                 var idpElements = document.getElementsByClassName('idp');
                 var emailError = document.getElementById(HRD.emailMismatch);

                 if ((emailError && emailError.innerHTML) || idpElements.length == 0)
                 {
                     HRD.showEmailInput();
                     u.setInitialFocus(HRD.emailInput);
                 }
                 else
                 {
                     HRD.hideEmailInput();
                 }

             } ();

             HRD.submitEmail = function () {
                 var u = new InputUtil();
                 var e = new HRDErrors()

                 var email = document.getElementById(HRD.emailInput);

                 if (!email.value || !email.value.match('[@]')) {
                     u.setError(email, e.invalidSuffix);
                     return false;
                 }

                 return true;
             };

             InputUtil.makePlaceholder(HRD.emailInput);

        //]]>
        </script>
     </div>


                    </div>
                </main>
                <div id="footerPlaceholder"></div>
            </div>
            <footer id="footer">
                <div id="footerLinks" class="floatReverse">
                    <div><span id="copyright">&#169; 2018 Microsoft</span><a id="privacy" class="pageLink footerLink" href="https://www.oecd.org/privacy/">Privacy Policy</a><a id="helpDesk" class="pageLink footerLink" href="https://www.oecd.org/termsandconditions/">Terms &amp; Conditions</a></div>
                </div>
            </footer>
        </div>     
    </div>
    <script type='text/javascript'>
//<![CDATA[
// Copyright (c) Microsoft Corporation.  All rights reserved.

// This file contains several workarounds on inconsistent browser behaviors that administrators may customize.
"use strict";

// iPhone email friendly keyboard does not include "\" key, use regular keyboard instead.
// Note change input type does not work on all versions of all browsers.
if (navigator.userAgent.match(/iPhone/i) != null) {
    var emails = document.querySelectorAll("input[type='email']");
    if (emails) {
        for (var i = 0; i < emails.length; i++) {
            emails[i].type = 'text';
        }
    }
}

// In the CSS file we set the ms-viewport to be consistent with the device dimensions, 
// which is necessary for correct functionality of immersive IE. 
// However, for Windows 8 phone we need to reset the ms-viewport's dimension to its original
// values (auto), otherwise the viewport dimensions will be wrong for Windows 8 phone.
// Windows 8 phone has agent string 'IEMobile 10.0'
if (navigator.userAgent.match(/IEMobile\/10\.0/)) {
    var msViewportStyle = document.createElement("style");
    msViewportStyle.appendChild(
        document.createTextNode(
            "@-ms-viewport{width:auto!important}"
        )
    );
    msViewportStyle.appendChild(
        document.createTextNode(
            "@-ms-viewport{height:auto!important}"
        )
    );
    document.getElementsByTagName("head")[0].appendChild(msViewportStyle);
}

// If the innerWidth is defined, use it as the viewport width.
if (window.innerWidth && window.outerWidth && window.innerWidth !== window.outerWidth) {
    var viewport = document.querySelector("meta[name=viewport]");
    viewport.setAttribute('content', 'width=' + window.innerWidth + ', initial-scale=1.0, user-scalable=1');
}

// Gets the current style of a specific property for a specific element.
function getStyle(element, styleProp) {
    var propStyle = null;

    if (element && element.currentStyle) {
        propStyle = element.currentStyle[styleProp];
    }
    else if (element && window.getComputedStyle) {
        propStyle = document.defaultView.getComputedStyle(element, null).getPropertyValue(styleProp);
    }

    return propStyle;
}

// The script below is used for downloading the illustration image 
// only when the branding is displaying. This script work together
// with the code in PageBase.cs that sets the html inline style
// containing the class 'illustrationClass' with the background image.
var computeLoadIllustration = function () {
    var branding = document.getElementById("branding");
    var brandingDisplay = getStyle(branding, "display");
    var brandingWrapperDisplay = getStyle(document.getElementById("brandingWrapper"), "display");

    if (brandingDisplay && brandingDisplay !== "none" &&
        brandingWrapperDisplay && brandingWrapperDisplay !== "none") {
        var newClass = "illustrationClass";

        if (branding.classList && branding.classList.add) {
            branding.classList.add(newClass);
        } else if (branding.className !== undefined) {
            branding.className += " " + newClass;
        }
        if (window.removeEventListener) {
            window.removeEventListener('load', computeLoadIllustration, false);
            window.removeEventListener('resize', computeLoadIllustration, false);
        }
        else if (window.detachEvent) {
            window.detachEvent('onload', computeLoadIllustration);
            window.detachEvent('onresize', computeLoadIllustration);
        }
    }
};

if (window.addEventListener) {
    window.addEventListener('resize', computeLoadIllustration, false);
    window.addEventListener('load', computeLoadIllustration, false);
}
else if (window.attachEvent) {
    window.attachEvent('onresize', computeLoadIllustration);
    window.attachEvent('onload', computeLoadIllustration);
}

// Function to change illustration image. Usage example below.
function SetIllustrationImage(imageUri) {
    var illustrationImageClass = '.illustrationClass {background-image:url(' + imageUri + ');}';

    var css = document.createElement('style');
    css.type = 'text/css';

    if (css.styleSheet) css.styleSheet.cssText = illustrationImageClass;
    else css.appendChild(document.createTextNode(illustrationImageClass));

    document.getElementsByTagName("head")[0].appendChild(css);
}

// Example to change illustration image on HRD page after adding the image to active theme:
// PSH> Set-AdfsWebTheme -TargetName <activeTheme> -AdditionalFileResource @{uri='/adfs/portal/images/hrd.jpg';path='.\hrd.jpg'}
//
//if (typeof HRD != 'undefined') {
//    SetIllustrationImage('/adfs/portal/images/hrd.jpg');
//}

////////////////////////////////////
// OECD CUSTOMIZATION STARTS HERE //
////////////////////////////////////

// MyOECD IDP Issuer
var myoecdAuthIdpIssuer = 'urn:myoecd'

// If HRD, go directly to MyOECD
if (typeof HRD != 'undefined') {
	HRD.selection(myoecdAuthIdpIssuer);
}

// Check if we are displaying the login page to include STS Auth URL
if (document.getElementById('authArea')) {

	// To support startWith method with IE 11 (required for opening documents in Office)
	if (!String.prototype.startsWith) {
	  String.prototype.startsWith = function(searchString, position) {
		position = position || 0;
		return this.indexOf(searchString, position) === position;
	  };
	}	

	// To support URLSearchParams with IE 11 (required for opening documents in Office)
	function GetURLParams(name){
		var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
		if (results == null){
		   return null;
		}
		else {
		   return decodeURI(results[1]) || 0;
		}
	}
	
	// For automatic redirection for OECD/IEA/ITF/NEA users
	var myoecdAuthIdpRedirect = 'RedirectToIdentityProvider=urn%3amyoecd';
	var stsAuthIdpRedirect = 'RedirectToIdentityProvider=http://sts.oecd.org/adfs/services/trust';
	var stswsUrl = 'https://stsws.oecd.org/anon/';

	// For looking at URL-encoded parameters and for redirection to IDP
	var currentUrl = window.location.href;
	
	// Changes of strings and localisation
	var locale = navigator.language.startsWith('fr')? 'fr' : 'en';
	//const params = new URLSearchParams(window.location.search);
	//var queryLocale = params.get('stslang');
	var queryLocale = GetURLParams('stslang');
	if ( (queryLocale === 'fr') || (queryLocale === 'en') ) {
		locale = queryLocale;
	}
	/*else {
		if (currentUrl.toLowerCase().indexOf("stslang%253dfr") != -1) {
			locale = 'fr';
		}
		else {
			if (currentUrl.toLowerCase().indexOf("stslang%253den") != -1) {
				locale = 'en';
			}
		}
	}*/

	var stsAuthUrl = '';
	if ( currentUrl.indexOf("?") != -1 ) {
		if (currentUrl.indexOf("RedirectToIdentityProvider") != -1) {
			// RedirectToIdentityProvider is present, we replace it
			stsAuthUrl = currentUrl.replace(myoecdAuthIdpRedirect, stsAuthIdpRedirect);			
		}
		else {
			// RedirectToIdentityProvider is not present, we add it
			stsAuthUrl = currentUrl + "&" + stsAuthIdpRedirect
		}
	} 
	else {
		// RedirectToIdentityProvider is not present, we add it
		stsAuthUrl = currentUrl + "&" + stsAuthIdpRedirect
	}
	
	var pwdResetUrl = 'https://account.oecd.org/SetPassword.aspx';
	var createAccountUrl = 'https://contact.oecd.org/';
	var ssoEnabledDomains = '@(((oecd|mopanonline|biac|mapsinitiative|tuac|tiwb|fatf-gafi|itf-oecd|oecd-nea|iea)\.org)|(gpai\.ai))$';
	var oecdTitle = 'Organisation for Economic Co-operation and Development';
	var oecdLogoPath = '/adfs/portal/images/logooecd_en.png';
	var oecdCopyright = 'OECD. All rights reserved.';
	var oecdHomeUrl = 'https://www.oecd.org/';
	var oecdPrivacy = 'Privacy Policy';
	var oecdPrivacyUrl = 'https://www.oecd.org/privacy/';
	var oecdHelpdesk = 'Terms & Conditions';
	var oecdHelpdeskUrl = 'https://www.oecd.org/termsandconditions/';
	var oecdLoginWithSSO = 'Sign in with SSO (OECD/IEA/ITF/NEA)';
	var oecdSignin = 'Already registered?';
	var oecdLogin = 'Login';
	var oecdPassword = 'Password';
	var oecdUserNameFormatError = 'Please enter your login.';
	var oecdPasswordEmpty = 'Please enter your password.';
	var oecdNextButton = 'Next';
	var oecdSubmitButton = 'Sign in';
	var oecdLoginError = 'Invalid login or password.';
	var oecdFirstVisitMessage = '<div id="firstVisitMessage" class="groupMargin">First visit?</div><div>Personalise your OECD site home page by selecting the themes that interest you to see only the news, events and documentation related to the themes you selected. You can also sign up for e-mail alerts (<b>OECDdirect</b>) and get notified about newsletters, new statistics and publications related to your selected themes.<br/><a href="' + createAccountUrl + '" target="_blank"><span id="createAccountButton" class="createAccount">Create Account</span></a></div>';
	var oecdStsLang = 'fr';
	var oecdStsLangText = 'Français';
	var oecdResetPassword = 'Reset password';
	var oecdErrorOccurred = 'Login not successful';
	var oecdNotAuthorizedError = 'Unfortunately, your login was not successful, which could be due to an expired password or to a suspended account.<br/>First, please click <a href="' + pwdResetUrl + '" target="_blank">here</a> to reset your password.<br/>If you are still unable to connect after resetting your password, this means that access for your account has been suspended. In this case, please contact O.N.E Support (<a href="mailto:one@oecd.org">one@oecd.org</a>) for more information.'
	var oecdUseSSOForEnabledDomains = 'Your account requires you to <a href="' + stsAuthUrl + '">sign in with SSO</a>.';
	var institutionalAccountsPattern = '^[0-9]{3}[A-Za-z]{6,12}$';
	var oecdUseInstitutionalAccountsPattern = 'It seems you\'ve entered an old institutional account (e.g. "001MINFRA") as your login. For security reasons, this is no longer possible.<br/>Please use your MyOECD account instead (in most cases this is your professional email).';
	var oecdErrorDetails = 'Error details';

	if (locale == 'fr') {
		oecdTitle = 'Organisation de coopération et de développement économiques';
		oecdCopyright = 'OCDE. Tous droits réservés.';
		oecdLogoPath = '/adfs/portal/images/logooecd_fr.png';
		oecdHomeUrl = 'https://www.oecd.org/fr/';
		oecdPrivacy = 'Protection des données et de la vie privée';
		oecdPrivacyUrl = 'http://www.oecd.org/fr/confidentialite/';
		oecdHelpdesk = 'Conditions d\'utilisation';
		oecdHelpdeskUrl = 'http://www.oecd.org/fr/conditionsdutilisation/';
		oecdLoginWithSSO = 'Se connecter en SSO (OECD/IEA/ITF/NEA)';
		oecdSignin = 'Déjà enregistré ?';
		oecdLogin = 'Identifiant';
		oecdPassword = 'Mot de passe';
		oecdUserNameFormatError = 'Veuillez entrer votre identifiant.';
		oecdPasswordEmpty = 'Veuillez entrer votre mot de passe.';
		oecdNextButton = 'Suivant';
		oecdSubmitButton = 'Se connecter';
		oecdLoginError = 'Identifiant ou mot de passe invalide.';
		oecdFirstVisitMessage = '<div id="firstVisitMessage" class="groupMargin">Nouveau venu ?</div><div>Personnalisez votre page d\'acceuil du site OCDE en sélectionnant vos centres d\intêret pour voir uniquement les nouvelles, les évenements et la documentation reliés à vos intérêts. Vous pouvez également souscrire à des alertes via courriels (<b>OECDdirect</b>) vous annonçant les nouveautés tel que des bulletins de nouvelles, de nouvelles statistiques et des publications liées à vos champs d’intérêts.<br/><a href="' + createAccountUrl + '" target="_blank"><span id="createAccountButton" class="createAccount">Créer un Compte</span></a></div>';
		oecdStsLang = 'en';
		oecdStsLangText = 'English';
		oecdResetPassword = 'Réinitialisation du mot de passe';
		oecdErrorOccurred = 'Echec de connexion';
		oecdNotAuthorizedError = 'Malheureusement votre connexion a échoué, ce qui peut être dû à votre mot de passe qui a expiré ou à votre compte qui a été suspendu.<br/>En premier lieu, veuillez cliquer <a href="' + pwdResetUrl + '" target="_blank">ici</a> pour réinitialiser votre mot de passe.<br/>Si vous ne parvenez toujours pas à vous connecter après avoir réinitialisé votre mot de passe, cela signifie que les accès liés à votre compte ont été suspendus. Dans ce cas, veuillez contacter le Support O.N.E (<a href="mailto:one@oecd.org">one@oecd.org</a>) pour plus d\'informations.'
		oecdUseSSOForEnabledDomains = 'Votre compte requiert de vous <a href="' + stsAuthUrl + '">connecter en SSO</a>.';
		oecdUseInstitutionalAccountsPattern = 'Il semble que vous ayez saisi un ancien compte institutionnel (ex : "001MINFRA") comme identifiant. Pour des raisons de sécurité, cela n\'est plus possible.<br/>Veuillez plutôt utiliser votre compte MyOECD (dans la plupart des cas, il s\'agit de votre adresse e-mail professionnelle).';
		oecdErrorDetails = 'Détails de l\'erreur';
	}
	
	// Process only if there is no error message
	if (document.getElementById('errorArea') == null) {
		// Function for automatic redirect when inside OECD
		if ( (currentUrl.toLowerCase().indexOf("forcelogin=true") == -1) && (currentUrl.toLowerCase().indexOf("forcelogin%253dtrue") == -1) ) {
			(function () {
				function loadScript(url, callback) {
					var script = document.createElement("script");
					script.type = "text/javascript";
				
					//console.log('Loading jQuery');
					if (script.readyState) { //IE
						script.onreadystatechange = function () {
							if (script.readyState === "loaded" || script.readyState === "complete") {
								script.onreadystatechange = null;
								callback();
							}
						};
					} else { //Others
						script.onload = function () {
							callback();
						};
					}
					script.src = url;
					document.getElementsByTagName("head")[0].appendChild(script);
				}
				
				loadScript("/adfs/portal/script/jquery.min.js", function () {
					// jQuery loaded
					//console.log('jQuery loaded');

					var getInfo = function (callback) {
						//console.log('Getting redirection info');

						var jqxhr = $.get( stswsUrl, function() {
							})
						.done(function() {
							//console.log('Redirection info: ' + jqxhr.responseText);
							var result = jqxhr.responseText;
							if (result == "anon") {
								callback(result);
							}
						})
					  
						.fail(function() {
							//console.log('Error querying redirection info: ' + jqxhr.responseText);
						});
					}	

					$(document).ready(function () {
						try {
							//$.ajaxSetup({xhrFields: { withCredentials: true } });
							getInfo(function(redirect) {
								if (redirect !== null) {
									//console.log('Redirect URL: ' + stsAuthUrl);
									window.location.href = stsAuthUrl;
								}	
							});
						}
						catch(err) {
							//console.log(err);
						} 
					});
				});
			})();
		}

		// Load functions to override default AD FS behaviour
		if (window.addEventListener) {
			window.addEventListener('load', override_form_validation, false);
		}
		else if (window.attachEvent) {
			window.attachEvent('onload', override_form_validation);
		}

		function override_form_validation() {
			Login.submitLoginRequest = function () {
				var u = new InputUtil();
				var e = new LoginErrors();

				var userName = document.getElementById(Login.userNameInput);
				var userNamePaginated = document.getElementById(Login.userNameInputHolder);
				var password = document.getElementById(Login.passwordInput);

				if (!userName && userNamePaginated) {
					userName = userNamePaginated;
				}

				//if (!userName.value || !userName.value.match('[@\\\\]')) {
				if (!userName.value) {
					u.setError(userName, oecdUserNameFormatError);
					return false;
				}

				if (!password.value) {
					u.setError(password, oecdPasswordEmpty, true);
					return false;
				}

				if (password.value.length > maxPasswordLength) {
					u.setError(password, e.passwordTooLong, true);
					return false;
				}

				password.value = password.value.trim();

				document.forms['loginForm'].submit();
				return false;
			};

			paginationManager.validateAndNext= function () {
				var u = new InputUtil();
				var e = new LoginErrors();

				var userName = document.getElementById(Login.userNameInput);

				if (!userName.value) {
				//if (!userName.value || !userName.value.match('[@\\\\]')) {
					u.setError(userName, oecdUserNameFormatError);
					return false;
				}

				if (userName.value.match(ssoEnabledDomains)) {
					window.location.href = stsAuthUrl;
					//u.setError(userName, oecdUseSSOForEnabledDomains);
					return false;
				}

				if (userName.value.match(institutionalAccountsPattern)) {
					u.setError(userName, oecdUseInstitutionalAccountsPattern);
					return false;
				}

				_self.updatePagesWithUsername(userName.value);
				u.clearError();

				if (_self.options.currentPageIndex + 1 >= _self.options.pages.length) {
					// POST back to ADFS since there are no more pages to go to 
					document.forms['loginFormPaginated'].submit();
					return true;
				} else {
					_self.displayNextPage();
				}
				
				return true;
			};
		}	
	}
	
	// Set OECD Title
	document.title = oecdTitle;
	
	// Set Logo
	document.getElementById('companyLogo').src = oecdLogoPath;
	
	// Set logo clickable
	var parentOfLogo = document.getElementById("companyLogo").parentElement;
	var imgLogoElement = parentOfLogo.innerHTML;
	parentOfLogo.innerHTML = '<a href="' + oecdHomeUrl + '">' + imgLogoElement + '</a>';

	// Set OECD Copyright and other footer text
	document.getElementById("copyright").innerText = oecdCopyright;
	document.getElementById("privacy").innerText = oecdPrivacy;
	document.getElementById("privacy").href = oecdPrivacyUrl;
	document.getElementById("helpDesk").innerText = oecdHelpdesk;
	document.getElementById("helpDesk").href = oecdHelpdeskUrl;
	if (document.getElementById("errorDetailsLink")) {
		document.getElementById("errorDetailsLink").innerText = oecdErrorDetails;
	}

	// Add First Visit part
	var firstVisitDiv = document.createElement("div");
	firstVisitDiv.id = 'firstVisitArea';
	firstVisitDiv.innerHTML = oecdFirstVisitMessage;
	document.getElementById('workArea').appendChild(firstVisitDiv);	

	// Only if no error
	if (document.getElementById('errorArea') == null) {
		// Add link "Sign in with SSO"
		var stsAuthDiv = document.createElement("div");
		stsAuthDiv.id = "footerStsAuthUrl"
		stsAuthDiv.innerHTML = "<a href='" + stsAuthUrl + "' class='pageLink footerLink'>" + oecdLoginWithSSO + "</a>";
		document.getElementById('footer').appendChild(stsAuthDiv);

		// Add Reset Password link
		var resetPasswordDiv = document.createElement("div");
		resetPasswordDiv.id = 'resetPasswordDiv';
		resetPasswordDiv.innerHTML = "<a href='" + pwdResetUrl + "' target='_blank'>" + oecdResetPassword + "</a>";
		document.getElementById('nextButtonArea').appendChild(resetPasswordDiv);	

		// Change some text
		document.getElementById('loginMessage').innerHTML = oecdSignin;
		document.getElementById('userNameInput').placeholder = oecdLogin;
		document.getElementById('passwordInput').placeholder = oecdPassword;
		document.getElementById('errorTextPassword').innerHTML = oecdLoginError;
		document.getElementById('nextButton').innerHTML = oecdNextButton;
		document.getElementById('submitButton').innerHTML = oecdSubmitButton;
	}
	
	// Add Switch Lang - Only if not IE
	if (window.document.documentMode === undefined)	{
		var switchLangDiv = document.createElement("div");
		switchLangDiv.id = 'switchLang';
		switchLangDiv.innerHTML = "<a href='' onclick=\"var langParams = new URLSearchParams(window.location.search);langParams.delete('stslang');langParams.append('stslang','" + oecdStsLang + "');window.location.href=window.location.href.split('?')[0] + '?' + langParams.toString();return false;\">" + oecdStsLangText + "</a>";
		document.getElementById('header').appendChild(switchLangDiv);	
	}	
	
	// If there is an error
	if (document.getElementById('errorArea')) {
		document.getElementById('authOptions').remove();
		document.getElementById('openingMessage').innerHTML = oecdErrorOccurred;
		document.getElementById('errorMessage').innerHTML = oecdNotAuthorizedError;
		
		var firstVisitDiv = document.getElementById('firstVisitArea');
		var ErrorDetailsDiv = document.createElement("div");
		ErrorDetailsDiv.id = 'firstVisitMessage';
		ErrorDetailsDiv.class = 'groupMargin';
		ErrorDetailsDiv.innerHTML = document.getElementById('errorDetailsLink').innerHTML;

		firstVisitDiv.replaceChildren();
		firstVisitDiv.appendChild(document.getElementById('errorDescription'));
		document.getElementById('errorDescription').prepend(ErrorDetailsDiv);
	}
	
	// Allow autocomplete - Only if not IE
	if (window.document.documentMode === undefined)	{
		if (document.getElementById("loginFormPaginated")) {
			if (document.getElementById("userNameInput")) {
				document.getElementById("userNameInput").autocomplete = 'username';
			}

			// Create a dummy password field to enable autocomplete in the login page
			var pwdPlaceholder = document.createElement("input");
			pwdPlaceholder.type = 'password';
			pwdPlaceholder.autocomplete = 'current-password';
			pwdPlaceholder.style = 'display:none;';
			document.getElementById('userNameArea').appendChild(pwdPlaceholder);
		}
		
		if (document.getElementById("loginForm")) {
			if (document.getElementById("userNameInputHolder")) {
				document.getElementById("userNameInputHolder").autocomplete = 'username';
				document.getElementById("userNameInputHolder").type = 'email';
				document.getElementById("userNameInputHolder").style = 'display:none;';
			}
			if (document.getElementById("passwordInput")) {
				document.getElementById("passwordInput").autocomplete = 'current-password';
			}
		}
	}
}

//]]>
</script>


    <script>(function(){function c(){var b=a.contentDocument||a.contentWindow.document;if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'9e246f1e3cfe5938',t:'MTc3NDUxMDA1OQ=='};var a=document.createElement('script');a.src='/cdn-cgi/challenge-platform/scripts/jsd/main.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script></body>
</html> 

