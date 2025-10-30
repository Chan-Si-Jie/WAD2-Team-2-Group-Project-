import { supabase } from "@/supabase";
import { userState } from "@/state/userState";

export const initAuth = async () => {
  // Check current session on page load
  const {
    data: { session },
  } = await supabase.auth.getSession();
  if (session?.user) {
    userState.loggedIn = true;
    userState.user = session.user;
  }

  // Subscribe to auth changes (login/logout)
  supabase.auth.onAuthStateChange((_event, session) => {
    if (session?.user) {
      userState.loggedIn = true;
      userState.user = session.user;
    } else {
      userState.loggedIn = false;
      userState.user = null;
    }
  });
};
