// Loading data from the CSV file
String getGasStatus(String gasName, double value) {
  if (gasName == 'Hydrogen') {
    if (value <= 100) {
      return "Normal";
    } else if (value >= 101 && value <= 700) {
      return "Medium";
    } else if (value >= 701 && value <= 1800) {
      return "High";
    } else if (value > 1800) {
      return "Critical";
    }
  } else if (gasName == 'Methane') {
    if (value <= 120) {
      return "Normal";
    } else if (value >= 121 && value <= 400) {
      return "Medium";
    } else if (value >= 401 && value <= 1000) {
      return "High";
    } else if (value > 1000) {
      return "Critical";
    }
  } else if (gasName == 'Ethane') {
    if (value <= 65) {
      return "Normal";
    } else if (value >= 66 && value <= 100) {
      return "Medium";
    } else if (value >= 101 && value <= 150) {
      return "High";
    } else if (value > 150) {
      return "Critical";
    }
  } else if (gasName == 'Ethylene') {
    if (value <= 50) {
      return "Normal";
    } else if (value >= 51 && value <= 100) {
      return "Medium";
    } else if (value >= 101 && value <= 200) {
      return "High";
    } else if (value > 200) {
      return "Critical";
    }
  } else if (gasName == 'Acetylene') {
    if (value <= 1) {
      return "Normal";
    } else if (value >= 2 && value <= 9) {
      return "Medium";
    } else if (value >= 10 && value <= 35) {
      return "High";
    } else if (value > 35) {
      return "Critical";
    }
  } else if (gasName == 'TDCG') {
    if (value <= 720) {
      return "Normal";
    } else if (value >= 721 && value <= 1920) {
      return "Medium";
    } else if (value >= 1921 && value <= 4630) {
      return "High";
    } else if (value > 4630) {
      return "Critical";
    }
  } else if (gasName == 'Carbon Dioxide') {
    if (value <= 100) {
      return "Normal";
    } else if (value >= 101 && value <= 700) {
      return "Medium";
    } else if (value >= 701 && value <= 1800) {
      return "High";
    } else if (value > 1800) {
      return "Critical";
    }
  } else if (gasName == 'Carbon Monoxide') {
    if (value <= 350) {
      return "Normal";
    } else if (value >= 351 && value <= 570) {
      return "Medium";
    } else if (value >= 571 && value <= 1400) {
      return "High";
    } else if (value > 1400) {
      return "Critical";
    }
  }
  return "Normal";
}
