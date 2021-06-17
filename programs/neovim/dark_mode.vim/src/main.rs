use core::f64;

use chrono::{Local, NaiveDateTime};
use is_dark::{GenericDetectDark, IsItDark, SmartTime};
use neovim_lib::{Neovim, NeovimApi, Session};

fn main() {
    let mut event_handler = EventHandler::new();
    event_handler.recv();
}

struct EventHandler {
    nvim: Neovim,
    darkmode: GenericDetectDark,
}

fn naive_datetime(s: &str) -> Option<NaiveDateTime> {
    let now = Local::now().naive_local();
    let time = {
        let ymd = now.format("%Y-%m-%d");
        let time =
            NaiveDateTime::parse_from_str(&format!("{} {}", ymd, s), "%Y-%m-%d %H:%M:%S").ok()?;
        if time < now {
            let tmrw = time.date().iter_days().next()?;
            let ymd = tmrw.format("%Y-%m-%d");
            NaiveDateTime::parse_from_str(&format!("{} {}", ymd, s), "%Y-%m-%d %H:%M:%S").ok()?
        } else {
            time
        }
    };

    Some(time)
}

fn calculate_smartime(long: Option<f64>, lat: Option<f64>, elev: Option<f64>) -> Option<SmartTime> {
    Some(SmartTime::new(long?, lat?, elev?))
}

impl EventHandler {
    fn new() -> EventHandler {
        let session = Session::new_parent().unwrap();
        let nvim = Neovim::new(session);
        EventHandler {
            nvim,
            darkmode: Default::default(),
        }
    }

    fn set_smartime(&mut self, refresh: bool) {
        let mut lat: Option<f64> = None;
        let mut long: Option<f64> = None;
        let mut elev: Option<f64> = None;
        let mut light_t: Option<chrono::NaiveDateTime> = None;
        let mut dark_t: Option<chrono::NaiveDateTime> = None;
        if let Ok(val) = self.nvim.get_option("dark_smart_time_lat") {
            lat = val.as_f64();
        }
        if let Ok(val) = self.nvim.get_var("dark_smart_time_long") {
            long = val.as_f64();
        }
        if let Ok(val) = self.nvim.get_var("dark_smart_time_elev") {
            elev = val.as_f64();
        }
        if let Ok(val) = self.nvim.get_var("dark_smart_time_tlight") {
            light_t = val.as_str().and_then(|s| naive_datetime(s));
        }
        if let Ok(val) = self.nvim.get_var("dark_smart_time_tdark") {
            dark_t = val.as_str().and_then(|s| naive_datetime(s));
        }
        if let Some(smt) = calculate_smartime(long, lat, elev) {
            self.darkmode = GenericDetectDark::new(Some(smt));
        } else if let Some(light) = light_t {
            if let Some(dark) = dark_t {
                self.darkmode = GenericDetectDark::new(Some(SmartTime::set_time(light, dark)))
            }
        }
        if refresh {
            match self.darkmode.is_dark() {
                Ok(dark) => {
                    let value = if dark { "dark" } else { "light" };

                    if self
                        .nvim
                        .command(&format!("set background={}", value))
                        .is_err()
                    {
                        self.nvim
                            .err_writeln(&format!("Failed to set background to {}", value))
                            .unwrap()
                    }
                },
                Err(e) => {
                   self.nvim.err_writeln(&format!("{:?}", e)).unwrap();
                },
            }
        }
    }

    fn recv(&mut self) {
        let rcv = self.nvim.session.start_event_loop_channel();
        self.set_smartime(true);
        while let Ok((evnt, _val)) = rcv.recv() {
            match Message::from(evnt) {
                // Message::SetDarkTime => { Not implemented upstream },
                // Message::SetLightTime => { Not implemented upstream },
                // Message::SetLatitude => { Not implemented upstream },
                // Message::SetLongitude => { Not implemented upstream },
                // Message::SetElevation => { Not implemented upstream },
                Message::Refresh => {
                    self.set_smartime(true);
                }
                Message::Unkown(_) => continue,
            }
        }
    }
}

#[derive(Debug)]
enum Message {
    // SetLightTime,
    // SetDarkTime,
    // SetLongitude,
    // SetLatitude,
    // SetElevation,
    Refresh,
    Unkown(String),
}

impl From<String> for Message {
    fn from(evnt: String) -> Self {
        match &evnt[..] {
            // "set_lat" => Message::SetLatitude,
            // "set_long" => Message::SetLongitude,
            // "set_elev" => Message::SetElevation,
            // "set_tdark" => Message::SetDarkTime,
            // "set_tlight" => Message::SetLightTime,
            "refresh" => Message::Refresh,
            _ => Message::Unkown(evnt),
        }
    }
}

// enum ThemeMode {
//     Dark,
//     Light,
//     Unknown(u8)
// }

// impl From<ThemeMode> for u8 {
//     fn from(val: ThemeMode) -> Self {
//         match val {
//             ThemeMode::Dark => 0,
//             ThemeMode::Light => 1,
//             ThemeMode::Unknown(u) => u
//         }
//     }
// }
