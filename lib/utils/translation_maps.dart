import 'package:get/get.dart';
import 'package:team_coffee/utils/string_resources.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // Add more English translations here
          AppStrings.mainDescMsg:
              "Experience the joy of shared meals, organize team snacks in just a few clicks.",
          AppStrings.successMsg: "Success",
          AppStrings.errorMsg: "Error",
          AppStrings.tryAgainMsg: 'Try Again',
          AppStrings.errorMsgEmptyName:
              'First name and last name cannot be empty',
          AppStrings.errorMsgFailUpdateProfile: "Failed to update profile:",
          AppStrings.successUpdateProfile: "Profile updated successfully",
          AppStrings.updateProfile: 'Update Profile',
          AppStrings.firstName: 'First Name',
          AppStrings.lastName: 'Last Name',
          AppStrings.email: 'Email address',
          AppStrings.pass: 'Password',
          AppStrings.typeInFirstName: 'Type in your first name',
          AppStrings.typeInLastName: 'Type in your last name',
          AppStrings.typeInLastName: 'Type in your last name',
          AppStrings.typeInEmail: 'Type in your email',
          AppStrings.emailSentTo: 'We\'ve sent a verification email to:',
          AppStrings.continueRegistration: 'Please continue your registration.',
          AppStrings.checkEmail:
              'Please check your email and click on the verification link to complete your registration.',
          AppStrings.openEmail: 'Open Email',
          AppStrings.or: 'Or',
          AppStrings.valid: 'Valid',
          AppStrings.joinGroup: 'Join Group',
          AppStrings.passWarningMsg:
              "Password needs to be at least 3 characters long",
          AppStrings.emailWarningMsg: "Email is not verified.",
          AppStrings.emailVerifiedMsg: "Email is verified.",
          AppStrings.emailCheckingStatus: 'Checking email status...',
          AppStrings.emailIntentErrorMsg: "Error opening email app:",
          AppStrings.userWarningMsg: "User registration is not complete.",
          AppStrings.userNotExistMsg: "User credentials are unauthorized.",
          AppStrings.changeYourPass: 'Change your password',
          AppStrings.cancel: 'Cancel',
          AppStrings.confirm: 'Confirm',
          AppStrings.update: 'Update',
          AppStrings.confirmPassChange: 'Confirm Password Change',
          AppStrings.confirmQuestionPassChange:
              'Are you sure you want to change your password?',
          AppStrings.submit: 'Submit',
          AppStrings.oldPass: 'Old Password',
          AppStrings.newPass: 'New Password',
          AppStrings.confirmPass: "Confirm Password",
          AppStrings.sameConfirmPass:
              "Please make sure, both passwords are same.",
          AppStrings.inviteFriends: 'Invite your friends',
          AppStrings.inviteBtn: 'INVITE',
          AppStrings.createEventWidget: 'Get some snacks for the team!',
          AppStrings.createEventSuccessWidget:
              'Successfully created new event!',
          AppStrings.eventCreationFailed: 'Failed to create new event.',
          AppStrings.shareMealsTogether: 'Share your meals together',
          AppStrings.inviteFriendsDesc:
              'Send invite to your friends or collagues to share good food and pleasant moments together.',
          AppStrings.notifications: 'Notifications',
          AppStrings.support: 'Support',
          AppStrings.editGroup: 'Edit Group',
          AppStrings.appMoto:
              'Feast, Friends, and Fun: Where Good Eats Meet Great Company',
          AppStrings.logout: 'Logout',
          AppStrings.signUpBold: 'SIGN UP',
          AppStrings.signUp: 'Sign up',
          AppStrings.signIn: 'Sign in',
          AppStrings.signInBold: 'SIGN IN',
          AppStrings.successRegistration: "Successful registration",
          AppStrings.finishRegistration: 'Finish your registration',
          AppStrings.rememberMe: "Remember me",
          AppStrings.forgotPass: "Forgot password?",
          AppStrings.noAccountQuestion: "Don't have an account?",
          AppStrings.confirmQuestionAccount: 'Have an account already?',
          AppStrings.differentMethods: "Use one of the following methods",
          AppStrings.followLink: 'by following this link',
          AppStrings.version: 'Version',
          AppStrings.timePending: "Time pending:",
          AppStrings.timeInProgress: "Time in progress:",
          AppStrings.organizer: 'Organizer',
          AppStrings.aboutEvent: 'About Event',
          AppStrings.contactOrganizer: "CONTACT ORGANIZER",
          AppStrings.makeOrder: "MAKE AN ORDER",
          AppStrings.eventsTitle: 'Events',
          AppStrings.authorTitle: 'Author',
          AppStrings.newEventTitle: 'Create new event',
          AppStrings.pizzaHint: 'Pizza from Gušti pizzeria',
          AppStrings.allFilter: 'ALL',
          AppStrings.coffeeFilter: 'COFFEE',
          AppStrings.foodFilter: 'FOOD',
          AppStrings.beverageFilter: 'BEVERAGE',
          AppStrings.eventDescHint: ' - Pizza margarita\n - Pizza vesuvio'
              '\n - Sandwich chicken cheese',
          AppStrings.timeUntilStart: 'Time until event starts: ',
          AppStrings.fillInAllFields: 'Please fill in all fields',
          AppStrings.emptyPendingEventText: "Hmm looks empty here",
          AppStrings.madeByText: "By",
          AppStrings.createTitle: 'CREATE',
          AppStrings.searchTitle: 'Search',
          AppStrings.searchAppBarTitle: 'Search',
          AppStrings.searchOrdersTitle: 'Search orders',
          AppStrings.searchEventsTitle: 'Search events',
          AppStrings.filtersTitle: "Filters",
          AppStrings.activeEventsTitle: "Active events",
          AppStrings.activeEventInProgressTitle:
              "There is already active event in progress",
          AppStrings.seeMoreTitle: "See more",
          AppStrings.howDoesItWorkTitle: 'How does it work?',
          AppStrings.Attendees: 'attendees',
          AppStrings.howDoesItWorkDesc: "Discover, Order, Enjoy:",
          AppStrings.howDoesItWorkMoto:
              'Your Team\'s Snack Experience Made Simple',
          AppStrings.exploreBottomNavBar: "Explore",
          AppStrings.myActivitiesBottomNavBar: "My activities",
          AppStrings.addBottomNavBar: "Add",
          AppStrings.leaderBottomNavBar: "Leaderboard",
          AppStrings.meBottomNavBar: "Me",
          AppStrings.leaderboardTitle: 'Leaderboard',
          AppStrings.ordersFilter: 'Orders',
          AppStrings.Date: 'Date',
          AppStrings.viewMyOrders: 'View My Orders',
          AppStrings.capsOrders: 'ORDERS',
          AppStrings.capsEvents: 'EVENTS',
          AppStrings.capsRating: 'RATING',
          AppStrings.scoreFilter: 'Score',
          AppStrings.loadMore: 'Load More',
          AppStrings.unranked: 'UNRANKED',
          AppStrings.noNotifications: 'No notifications',
          AppStrings.noRatings: 'No active ratings',
          AppStrings.finish: 'Finish',
          AppStrings.finishBold: 'Finish',
          AppStrings.cancelEvent: 'CANCEL EVENT',
          AppStrings.youSure: 'Are you sure?',
          AppStrings.youSureEvent: 'Are you sure you want to finish the event?',
          AppStrings.noOrders: "No orders yet",
          AppStrings.activeOrders: 'Active',
          AppStrings.completedOrders: 'Completed',
          AppStrings.showCancelled: "Show Cancelled Orders",
          AppStrings.noMore: 'No more',
          AppStrings.any: "ANY",
          AppStrings.orderDetails: "Order details",
          AppStrings.profileStats: 'Profile Statistics',
          AppStrings.monthlyStats: 'Monthly Statistics',
          AppStrings.noData: 'No data',
          AppStrings.byStatus: 'By Status',
          AppStrings.byType: 'By Type',
          AppStrings.failLoadMsg: 'Failed to load data:',
          AppStrings.yourGroupsMsg: "Your Groups",
          AppStrings.rolesText: "Roles",
          AppStrings.continueToHomeBtn: 'Continue to Home',
          AppStrings.errorMsgFailUnauthorized:
              "You are unauthorized for this action!",
          AppStrings.changePassText: 'Change your password',
          'Filter': 'Filter',
          'Event status': 'Event status',
          'Time & Date': 'Time & Date',
          'ALL': 'ALL',
          'COFFEE': 'COFFEE',
          'FOOD': 'FOOD',
          'BEVERAGE': 'BEVERAGE',
          'Pending': 'Pending',
          'In progress': 'In Progress',
          'Completed': 'Completed',
          'TODAY': 'TODAY',
          'TOMORROW': 'TOMORROW',
          'THIS_WEEK': 'THIS WEEK',
          'Choose from calendar': 'Choose from calendar',
          'RESET': 'RESET',
          'APPLY': 'APPLY',
          'PENDING': 'PENDING',
          'IN PROGRESS': 'IN PROGRESS',
          'IN_PROGRESS': 'IN PROGRESS',
          'COMPLETED': 'COMPLETED',
          'MY ORDER': 'MY ORDER',
          "FINISHED": "FINISHED",
          'Monthly Statistics': 'Monthly Statistics',
          'Select Group': 'Select Group',
          "Error occurred": "Error occurred",
          "Warning": "Warning",
          "That name is already taken": "That name is already taken",
          "Group name": "Group name",
          "Short description": "Short description",
          "Your password": "Your password",
          "Confirm password": "Confirm password",
          "CONTINUE": "CONTINUE",
        },
        'hr_HR': {
          // Croatian translation
          AppStrings.mainDescMsg:
              "Uživajte u zajedničkom obroku, organizirajte grupnu marendu u samo par klikova.",
          AppStrings.successMsg: "Uspjeh",
          AppStrings.errorMsg: "Greška",
          AppStrings.joinGroup: 'Pridruži se grupi',
          AppStrings.followLink: 'klikom na ovaj link',
          AppStrings.createGroup: 'Stvori grupu',
          AppStrings.tryAgainMsg: 'Pokušaj ponovno',
          AppStrings.errorMsgEmptyName: 'Ime i prezime ne mogu biti prazni',
          AppStrings.errorMsgFailUpdateProfile: "Neuspjelo ažuriranje profila:",
          AppStrings.errorMsgFailUnauthorized:
              "Niste autorizirani za provođenje ove radnje!",
          AppStrings.successUpdateProfile: "Profil uspješno ažuriran",
          AppStrings.updateProfile: 'Ažuriraj profil',
          AppStrings.firstName: 'Ime',
          AppStrings.lastName: 'Prezime',
          AppStrings.email: 'E-mail adresa',
          AppStrings.pass: 'Lozinka',
          AppStrings.typeInFirstName: 'Unesite svoje ime',
          AppStrings.typeInLastName: 'Unesite svoje prezime',
          AppStrings.typeInEmail: 'Unesite svoju e-mail adresu',
          AppStrings.emailSentTo: 'Poslali smo e-mail za potvrdu na:',
          AppStrings.continueRegistration: 'Molimo nastavite s registracijom.',
          AppStrings.checkEmail:
              'Molimo provjerite svoj e-mail i kliknite na link za potvrdu kako biste dovršili registraciju.',
          AppStrings.openEmail: 'Otvori e-mail',
          AppStrings.or: 'Ili',
          AppStrings.valid: 'Valjano',
          AppStrings.passWarningMsg: "Lozinka mora imati najmanje 3 znaka",
          AppStrings.emailWarningMsg: "E-mail nije potvrđen.",
          AppStrings.emailVerifiedMsg: "E-mail je potvrđen.",
          AppStrings.emailCheckingStatus: 'Provjera statusa e-maila...',
          AppStrings.emailIntentErrorMsg:
              "Greška pri otvaranju e-mail aplikacije:",
          AppStrings.userWarningMsg: "Registracija korisnika nije dovršena.",
          AppStrings.changeYourPass: 'Promijeni svoju lozinku',
          AppStrings.cancel: 'Odustani',
          AppStrings.confirm: 'Potvrdi',
          AppStrings.update: 'Ažuriraj',
          AppStrings.confirmPassChange: 'Potvrdi promjenu lozinke',
          AppStrings.shareMealsTogether: 'Podijeli marendu s ekipom',
          AppStrings.confirmQuestionPassChange:
              'Jeste li sigurni da želite promijeniti lozinku?',
          AppStrings.submit: 'Pošalji',
          AppStrings.oldPass: 'Stara lozinka',
          AppStrings.newPass: 'Nova lozinka',
          AppStrings.confirmPass: "Potvrdi lozinku",
          AppStrings.capsOrders: 'NARUDŽBE',
          AppStrings.capsEvents: 'GABLECI',
          AppStrings.capsRating: 'OCJENA',
          AppStrings.sameConfirmPass:
              "Molimo provjerite jesu li obje lozinke iste.",
          AppStrings.inviteFriends: 'Pozovi prijatelje',
          AppStrings.createEventWidget: 'Riješi neku marendu za ekipu!',
          AppStrings.createEventSuccessWidget: 'Uspješno kreiran novi gablec!',
          AppStrings.eventCreationFailed:
              'Pogrerška pri kreiranju novog gableca.',
          AppStrings.emptyPendingEventText: "Hmm ovdje je nešto prazno",
          AppStrings.inviteFriendsDesc:
              'Pošaljite pozivnicu svojim prijateljima ili kolegama da zajedno dijelite dobru hranu i ugodne trenutke.',
          AppStrings.notifications: 'Obavijesti',
          AppStrings.support: 'Podrška',
          AppStrings.editGroup: 'Uredi grupu',
          AppStrings.appMoto:
              'Gozba, prijatelji i zabava: Gdje se dobra hrana susreće s dobrim društvom',
          AppStrings.logout: 'Odjava',
          AppStrings.signUpBold: 'REGISTRACIJA',
          AppStrings.signUp: 'Registriraj se',
          AppStrings.signIn: 'Prijavi se',
          AppStrings.signInBold: 'PRIJAVA',
          AppStrings.successRegistration: "Uspješna registracija",
          AppStrings.finishRegistration: 'Dovršite svoju registraciju',
          AppStrings.rememberMe: "Zapamti me",
          AppStrings.forgotPass: "Zaboravili ste lozinku?",
          AppStrings.noAccountQuestion: "Nemate račun?",
          AppStrings.confirmQuestionAccount: 'Već imate račun?',
          AppStrings.differentMethods: "Koristite jednu od sljedećih metoda",
          AppStrings.version: 'Verzija',
          AppStrings.timePending: "Preostalo vrijeme:",
          AppStrings.timeInProgress: "Vrijeme u tijeku:",
          AppStrings.organizer: 'Organizator',
          AppStrings.aboutEvent: 'O događaju',
          AppStrings.contactOrganizer: "KONTAKTIRAJ ORGANIZATORA",
          AppStrings.makeOrder: "NAPRAVI NARUDŽBU",
          AppStrings.eventsTitle: 'Događaji',
          AppStrings.authorTitle: 'Autor',
          AppStrings.newEventTitle: 'Stvori novi događaj',
          AppStrings.pizzaHint: 'Pizza iz Gušti pizzerije',
          AppStrings.madeByText: "Od",
          AppStrings.allFilter: 'SVE',
          AppStrings.coffeeFilter: 'KAVA',
          AppStrings.foodFilter: 'HRANA',
          AppStrings.beverageFilter: 'PIĆE',
          AppStrings.eventDescHint: ' - Pizza margarita\n - Pizza vesuvio'
              '\n - Sendvič piletina sir',
          AppStrings.timeUntilStart: 'Vrijeme do početka događaja: ',
          AppStrings.fillInAllFields: 'Molimo ispunite sva polja',
          AppStrings.createTitle: 'STVORI',
          AppStrings.searchTitle: 'Pretraži',
          AppStrings.searchAppBarTitle: 'Traži',
          AppStrings.searchOrdersTitle: 'Pretraži narudžbe',
          AppStrings.searchOrdersTitle: 'Pretraži gablece',
          AppStrings.filtersTitle: "Filteri",
          AppStrings.activeEventsTitle: "Aktivni događaji",
          AppStrings.activeEventInProgressTitle:
              "Već postoji aktivan gablec u tijeku",
          AppStrings.seeMoreTitle: "Vidi više",
          AppStrings.howDoesItWorkTitle: 'Kako to funkcionira?',
          AppStrings.howDoesItWorkDesc: "Otkrijte, naručite, uživajte:",
          AppStrings.inviteBtn: 'POZOVI',
          AppStrings.howDoesItWorkMoto:
              'Iskustvo grickalica vašeg tima učinjeno jednostavnim',
          AppStrings.exploreBottomNavBar: "Istraži",
          AppStrings.myActivitiesBottomNavBar: "Moje aktivnosti",
          AppStrings.addBottomNavBar: "Dodaj",
          AppStrings.leaderBottomNavBar: "Ljestvica",
          AppStrings.meBottomNavBar: "Ja",
          AppStrings.leaderboardTitle: 'Ljestvica',
          AppStrings.ordersFilter: 'Narudžbe',
          AppStrings.viewMyOrders: 'Pregledaj moje narudžbe',
          AppStrings.Attendees: 'sudionika',
          AppStrings.scoreFilter: 'Ocjena',
          AppStrings.loadMore: 'Učitaj više',
          AppStrings.unranked: 'BEZ RANGA',
          AppStrings.noNotifications: 'Nema obavijesti',
          AppStrings.noRatings: 'Nema aktivnog poretka',
          AppStrings.finish: 'Završi',
          AppStrings.finishBold: 'ZAVRŠI',
          AppStrings.cancelEvent: 'OTKAŽI DOGAĐAJ',
          AppStrings.youSure: 'Jeste li sigurni?',
          AppStrings.youSureEvent:
              'Jeste li sigurni da želite završiti događaj?',
          AppStrings.userNotExistMsg: "Došlo je do pogreške prilikom prijave.",
          AppStrings.noOrders: "Još nema narudžbi",
          AppStrings.activeOrders: 'Aktivne',
          AppStrings.completedOrders: 'Završene',
          AppStrings.showCancelled: "Prikaži otkazane narudžbe",
          AppStrings.noMore: 'Nema više',
          AppStrings.any: "SVE",
          AppStrings.orderDetails: "Detalji narudžbe",
          AppStrings.profileStats: 'Statistika profila',
          AppStrings.monthlyStats: 'Mjesečna statistika',
          AppStrings.noData: 'Nema podataka',
          AppStrings.byStatus: 'Po statusu',
          AppStrings.byType: 'Po vrsti',
          AppStrings.failLoadMsg: 'Pogreška pri učitavanju podataka:',
          AppStrings.yourGroupsMsg: "Tvoje Grupe",
          AppStrings.rolesText: "Ovlasti",
          AppStrings.continueToHomeBtn: 'Nastavi na Početni',
          AppStrings.changePassText: 'Promijeni svoju lozinku',
          AppStrings.Date: 'Datum',
          'Filter': 'Filter',
          'Event status': 'Status događaja',
          'Time & Date': 'Vrijeme i datum',
          'ALL': 'SVE',
          'COFFEE': 'KAVA',
          'FOOD': 'HRANA',
          'BEVERAGE': 'PIĆE',
          'Pending': 'Čekanje',
          'In Progress': 'U tijeku',
          'Completed': 'Završeno',
          'TODAY': 'DANAS',
          'TOMORROW': 'SUTRA',
          'THIS_WEEK': 'OVAJ TJEDAN',
          'Choose from calendar': 'Odaberi iz kalendara',
          'RESET': 'PONIŠTI',
          'APPLY': 'PRIMIJENI',
          'PENDING': 'ČEKANJE',
          'IN PROGRESS': 'U TIJEKU',
          'IN_PROGRESS': 'U TIJEKU',
          'COMPLETED': 'ZAVRŠENO',
          'MY ORDER': 'MOJA NARUDŽBA',
          "FINISHED": "ZAVRŠENO",
          'Monthly Statistics': 'Mjesečna Statistika',
          'Select Group': 'Odaberi Grupu',
          "Error occurred": "Dogodila se greška",
          "Warning": "Upozorenje",
          "That name is already taken": "Upisano ime je već zauzeto",
          "Group name": "Ime grupe",
          "Short description": "Kratak opis",
          "Your password": "Tvoja lozinka",
          "Confirm password": "Potvrdi lozinku",
          "CONTINUE": "NASTAVI"
        },

        'de_DE': {
          // Add more German translations here
        },
        // Add more languages here
      };
}
