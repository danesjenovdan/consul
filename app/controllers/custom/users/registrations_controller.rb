require_dependency Rails.root.join('app', 'controllers', 'users', 'registrations_controller').to_s

class Users::RegistrationsController < Devise::RegistrationsController
  def get_balloted_heading_id(address)
    balloted_heading_id = 0
    if address.include? "Topol pri Medvodah"
      balloted_heading_id = 1
    end
    if address.include? "Belo"
      balloted_heading_id = 1
    end
    if address.include? "Brezovica pri Medvodah"
      balloted_heading_id = 1
    end
    if address.include? "Tehovec"
      balloted_heading_id = 1
    end
    if address.include? "Trnovec"
      balloted_heading_id = 1
    end
    if address.include? "Setnica"
      balloted_heading_id = 1
    end
    if address.include? "Arharjeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Barletova cesta 2"
      balloted_heading_id = 2
    end
    if address.include? "Cesta komandanta Staneta"
      balloted_heading_id = 2
    end
    if address.include? "Cesta na Senico"
      balloted_heading_id = 2
    end
    if address.include? "Cesta na Svetje"
      balloted_heading_id = 2
    end
    if address.include? "Cesta ob Sori"
      balloted_heading_id = 2
    end
    if address.include? "Cesta talcev"
      balloted_heading_id = 2
    end
    if address.include? "Čarmanova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Čelesnikova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Dimčeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Donova cesta"
      balloted_heading_id = 2
    end
    if address.include? "Finžgarjeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Gorenjska cesta"
      balloted_heading_id = 2
    end
    if address.include? "Grajzerjeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Jamnikova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Kebetova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Klanska ulica"
      balloted_heading_id = 2
    end
    if address.include? "Kržišnikova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Kuraltova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Ostrovrharjeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Medvoška cesta"
      balloted_heading_id = 2
    end
    if address.include? "Podvizova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Seškova cesta"
      balloted_heading_id = 2
    end
    if address.include? "Šetinova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Šlosarjeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Šmalčeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Štalčeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Tehovnikova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Trampuževa ulica"
      balloted_heading_id = 2
    end
    if address.include? "Turkova ulica"
      balloted_heading_id = 2
    end
    if address.include? "Ulica Ivanke Ovijač"
      balloted_heading_id = 2
    end
    if address.include? "Ulica k studencu"
      balloted_heading_id = 2
    end
    if address.include? "Ulica ob gozdu"
      balloted_heading_id = 2
    end
    if address.include? "Ulica Simona Jenka"
      balloted_heading_id = 2
    end
    if address.include? "Višnarjeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Zbiljska cesta"
      balloted_heading_id = 2
    end
    if address.include? "Žontarjeva ulica"
      balloted_heading_id = 2
    end
    if address.include? "Verje"
      balloted_heading_id = 3
    end
    if address.include? "Zgornje Pirniče"
      balloted_heading_id = 3
    end
    if address.include? "Spodnje Pirniče"
      balloted_heading_id = 3
    end
    if address.include? "Vikrče"
      balloted_heading_id = 3
    end
    if address.include? "Zavrh pod Šmarno goro"
      balloted_heading_id = 3
    end
    if address.include? "Barletova cesta"
      balloted_heading_id = 4
    end
    if address.include? "Bečanova ulica"
      balloted_heading_id = 4
    end
    if address.include? "Bergantova cesta"
      balloted_heading_id = 4
    end
    if address.include? "Bernikova ulica"
      balloted_heading_id = 4
    end
    if address.include? "Bizantova cesta"
      balloted_heading_id = 4
    end
    if address.include? "Bogatajeva ulica"
      balloted_heading_id = 4
    end
    if address.include? "Cesta ob železnici"
      balloted_heading_id = 4
    end
    if address.include? "Cesta v Bonovec"
      balloted_heading_id = 4
    end
    if address.include? "Cesta v Žlebe"
      balloted_heading_id = 4
    end
    if address.include? "Dobnikarjeva ulica"
      balloted_heading_id = 4
    end
    if address.include? "Hrastarjeva ulica"
      balloted_heading_id = 4
    end
    if address.include? "Iztokova ulica"
      balloted_heading_id = 4
    end
    if address.include? "Kalanova ulica"
      balloted_heading_id = 4
    end
    if address.include? "Kurirska cesta"
      balloted_heading_id = 4
    end
    if address.include? "Na Čerenu"
      balloted_heading_id = 4
    end
    if address.include? "Preška cesta"
      balloted_heading_id = 4
    end
    if address.include? "Škofjeloška cesta"
      balloted_heading_id = 4
    end
    if address.include? "Trilerjeva ulica"
      balloted_heading_id = 4
    end
    if address.include? "Spodnja Senica"
      balloted_heading_id = 5
    end
    if address.include? "Zgornja Senica"
      balloted_heading_id = 5
    end
    if address.include? "Ladja"
      balloted_heading_id = 5
    end
    if address.include? "Seničica"
      balloted_heading_id = 6
    end
    if address.include? "Golo Brdo"
      balloted_heading_id = 6
    end
    if address.include? "Smlednik"
      balloted_heading_id = 7
    end
    if address.include? "Valburga"
      balloted_heading_id = 7
    end
    if address.include? "Hraše"
      balloted_heading_id = 7
    end
    if address.include? "Dragočajna"
      balloted_heading_id = 7
    end
    if address.include? "Moše"
      balloted_heading_id = 7
    end
    if address.include? "Sora"
      balloted_heading_id = 8
    end
    if address.include? "Rakovnik"
      balloted_heading_id = 8
    end
    if address.include? "Dol"
      balloted_heading_id = 8
    end
    if address.include? "Osolnik"
      balloted_heading_id = 8
    end
    if address.include? "Vaše"
      balloted_heading_id = 9
    end
    if address.include? "Goričane"
      balloted_heading_id = 9
    end
    if address.include? "Zbilje"
      balloted_heading_id = 10
    end
    if address.include? "Studenčice"
      balloted_heading_id = 11
    end
    if address.include? "Žlebe"
      balloted_heading_id = 11
    end

    balloted_heading_id += 5
    return balloted_heading_id
  end

  def sign_up_params
    params[:user].delete(:redeemable_code) if params[:user].present? && params[:user][:redeemable_code].blank?
    params[:user][:balloted_heading_id] = get_balloted_heading_id(params[:user][:address])
    params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation, :terms_of_service, :locale,
                                 :document_type, :document_number,
                                 :redeemable_code, :phone, :address, :is_anonymous, :data_consent,
                                 :balloted_heading_id)
  end
end
