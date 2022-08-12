#!/bin/bash
file="/home/jay/Downloads/site"
country_names="Honduras|United Arab Emirates|Djibouti|Seychelles|Antigua and Barbuda|Vietnam|Hungary|Tajikistan|Belarus|Austria|Fiji|DR Congo|Papua New Guinea|Serbia|Comoros|Israel|Switzerland|Turkey|Iran|Germany|Togo|Holy See|Sierra Leone|Guyana|Andorra|Bhutan|Laos|Dominica|Paraguay|Thailand|Bulgaria|Libya|Solomon Islands|Lebanon|United Kingdom|Nicaragua|France|Kyrgyzstan|El Salvador|Montenegro|Luxembourg|Italy|Turkmenistan|Tanzania|South Africa|Marshall Islands|Suriname|Singapore|Denmark|Cabo Verde|Finland|Congo|Micronesia|Slovakia|Myanmar|Norway|Maldives|Kenya|Saint Kitts & Nevis|South Korea|Oman|State of Palestine|Costa Rica|Colombia|Liberia|Ireland|Central African Republic|New Zealand|Spain|Mauritania|Uganda|Argentina|Malta|Algeria|Sudan|Brunei|Ukraine|Panama|Kuwait|Croatia|Moldova|Iraq|Georgia|Belize|Bahamas|Monaco|Afghanistan|Liechtenstein|Poland|Canada|Morocco|Eritrea|Saudi Arabia|Uruguay|Iceland|San Marino|Uzbekistan|United States|Peru|Angola|Bosnia and Herzegovina|Mongolia|Malaysia|Mozambique|Ghana|Vanuatu|Yemen|Armenia|Jamaica|Nepal|Qatar|Albania|Barbados|Venezuela|Madagascar|Indonesia|Lithuania|Cameroon|Côte d'Ivoire|North Korea|Australia|Namibia|Niger|Gambia|Botswana|Gabon|Pakistan|Sao Tome & Principe|Lesotho|Sri Lanka|Brazil|Burkina Faso|North Macedonia|Slovenia|Nigeria|Mali|Samoa|Guinea-Bissau|Romania|Malawi|Chile|Latvia|Kazakhstan|Zambia|Saint Lucia|Palau|Guatemala|Ecuador|Syria|Netherlands|Bahrain|Senegal|Cambodia|Bangladesh|Chad|Somalia|Zimbabwe|Russia|China|Equatorial Guinea|Trinidad and Tobago|Estonia|Timor-Leste|Guinea|Rwanda|Mexico|Mauritius|Japan|Benin|Cyprus|Kiribati|Burundi|Tunisia|Tuvalu|Bolivia|Eswatini|Belgium|Ethiopia|Haiti|Cuba|Grenada|South Sudan|St. Vincent & Grenadines|Philippines|Dominican Republic|Nauru|Czech Republic (Czechia)|Tonga|Greece|Egypt|Jordan|Portugal|Azerbaijan|Sweden|India|USA|UK"
potential_urls="/tmp/potential_urls"
ignored_file="/tmp/ignored_url"

# Check for multiple countries

for url in $(cat $file); 
do
    countries=$(timeout 10 curl -Lik ${url} 2> /dev/null| grep -E -wo "${country_names}" | uniq | wc -l )
    if [[ ${countries} -gt 1 ]]; then
        available_countries=$(timeout 10 curl -Lik ${url} 2> /dev/null| grep -E -wo "${country_names}" | uniq | tr '\n' ',')
        echo "[+] $url may present in multiple locations. || Locations: ${available_countries}"
        echo "$url" >> $potential_urls
        echo "====================================================================================="
    else
        echo "[-] Ignored: ${url}" >> ${ignored_file}
    fi
done

#remove potential urls from the file
echo "[#] Removing matched URL's from the file."
for i in $(cat $potential_urls); do sed -i "/$i/d" $file ; echo "$i matched & removed from the $file!" ; done

exit 0

