ten[] bunkatsu(ten center, ten[] others) {

  sen[] takusan;
  ten[] online;
  ten[] allpoint;
  ArrayList<ten> kakutei = new ArrayList();

  int nagasa = others.length+waku.length;

  allpoint = new ten[nagasa*(nagasa-1)/2];

  takusan = new sen[nagasa];
  boolean[] proceed = new boolean[nagasa];
  sen nearline;

  for (int i = 0; i < nagasa; i++) {
    if (i<others.length) {
      takusan[i] = new sen(center, others[i]);
    } else {
      takusan[i] = waku[i-others.length];
    }
    proceed[i] = false;
  }
  {
    int apcount = 0;
    for (int i = 0; i < nagasa; i++) {
      for (int j = i + 1; j < nagasa; j++) {
        allpoint[apcount] = 
          cross(takusan[i], takusan[j]);
        apcount++;
      }
    }
  }

  {
    float nearestdist = 1145141919;
    int nearestnumb = -1;
    for (int i = 0; i < nagasa; i++) {

      float sans = distsq(center, takusan[i]);

      if (sans < nearestdist) {
        nearestdist = sans;
        nearestnumb = i;
      }
    }
    nearline = takusan[nearestnumb];
    if (nearline.borntobefree) {
      sen asgore = new sen(nearline.b, -nearline.a, 
        nearline.b*center.x-nearline.a*center.y);
      nearline.suiten = cross(nearline, asgore);
    }
  }

  online = resetonline(nearline, allpoint);

  {
    float distplus = 1145141919, 
      distminus = -1145141919;
    int nearplus = -1, nearminus = -1;

    ten justin = nearline.suiten;
    for (int i = 0; i<online.length; i++) {
      ten matsutaka = online[i];

      float toriel = 
        matsutaka.x - justin.x + 
        matsutaka.y - justin.y;
      if (toriel > 0 & toriel < distplus) {
        nearplus = i;
        distplus = toriel;
      } else if (toriel < 0 & toriel > distminus) {
        nearminus = i;
        distminus = toriel;
      }
    }

    if (nearplus!=-1)kakutei.add(online[nearplus]);
    if (nearminus!=-1)kakutei.add(online[nearminus]);
  }

  sen temp = nearline;
  sen temp2 = temp;

  while (true) {
    ten uzuki = kakutei.get(kakutei.size()-1);

    temp = uzuki.parent[0]==temp
      ?uzuki.parent[1]:uzuki.parent[0];

    online = resetonline(temp, allpoint);

    ten[] cookie = getneighbor(uzuki, online);
    if (cookie.length == 0)break;

    if (cookie[1]==null) {
      uzuki = cookie[0];
    } else if (!beyond(center, cookie[1], temp2)) {
      uzuki = cookie[1];
    } else {
      uzuki = cookie[0];
    }

    if (kakutei.indexOf(uzuki) != -1) {
      break;
    } else {
      kakutei.add(uzuki);
      temp2 = temp;
    }
  }
  return kakutei.toArray(new ten[kakutei.size()]);
}

ten[] getneighbor(ten _a, ten[] online) {
  int you = -1;
  for (int i = 0; i < online.length; i++) {
    if (online[i]==_a) {
      you = i;
      break;
    }
  }
  if (you==-1)return new ten[0];
  ten[] going = new ten[2];
  int n = 0;
  int claris = 0;
  for (int j = 0; j<online.length; j++) {
    ten papyrus = online[j];
    if (_a.x + _a.y > papyrus.x + papyrus.y)n++;
  }
  for (int i = 0; i<online.length; i++) {
    int count = 0;
    ten sans = online[i];
    for (int j = 0; j<online.length; j++) {
      ten papyrus = online[j];
      if (sans.x + sans.y > papyrus.x + papyrus.y)
        count++;
    }
    if (count == n - 1 | count == n + 1) {
      going[claris] = sans;
      claris++;
      if (claris == 2)return going;
    }
  }
  return going;
}

ten[] resetonline(sen _nearline, ten[] allpoint) {
  ten[] ketsudeka = new ten[allpoint.length];
  int count = 0;
  for (ten matsutaka : allpoint) 
    if (matsutaka!=null) 
      if (matsutaka.parent[0] == _nearline
        |matsutaka.parent[1] == _nearline) {
        ketsudeka[count] = matsutaka;
        count++;
      }
  ten[] online = new ten[count];
  for (int j = 0; j < count; j++) 
    online[j] = ketsudeka[j];
  return online;
}