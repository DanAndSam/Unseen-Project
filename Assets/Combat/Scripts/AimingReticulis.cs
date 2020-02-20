using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using DG.Tweening;
using UnityEngine;

public class AimingReticulis : MonoBehaviour
{
    public float reticuleTotalTime = 0;
    public float additionWindowTime = 0;

    //public int reticulisModifierStat = 0;

    public GameObject reticulisPrefab;
    public GameObject reticulis;
    public GameObject reticulisTarget;
    public GameObject reticulisWhiteCenter;
    public bool isReticulisTime = false;
    public float reticulisScaleFactor = 3;

    private int numberOfRiticuleRotations = 1;
    private bool canLaunchRiticule = true;
    private Vector3 reticulisStartRot = new Vector3();
    private Vector3 reticulisStartScale = new Vector3();
    private Color reticulisStartColor = new Color();

    private void Start()
    {
        reticulisStartRot = reticulis.transform.eulerAngles;
        reticulisStartScale = reticulis.transform.localScale;
        reticulisStartColor = reticulis.GetComponent<Image>().color;
    }

    public void Launch(float reticuleTime)
    {
        StartCoroutine(StartReticulis(reticuleTime));
    }    

    private IEnumerator StartReticulis(float reticuleTime)
    {

        yield return new WaitForSeconds(reticuleTime - reticuleTotalTime);
        float reticuleAnimationLength = reticuleTotalTime - additionWindowTime;
        GameObject reticule = Instantiate(reticulisPrefab);
        reticule.transform.SetParent(transform);
        reticule.transform.localPosition = Vector3.zero;        

        reticulisTarget.SetActive(true);    

        reticule.transform.DORotate(reticulisTarget.transform.eulerAngles,  reticuleAnimationLength);
        reticule.transform.DOScale(reticulisTarget.transform.localScale, reticuleAnimationLength);

        float windowDelay = reticuleAnimationLength - additionWindowTime;

        yield return new WaitForSeconds(windowDelay);
        isReticulisTime = true;
        CombatManager.Instance.SetPlayerCanAddition(isReticulisTime);
        reticulisWhiteCenter.SetActive(true);
        yield return new WaitForSeconds(additionWindowTime);
        isReticulisTime = false;
        CombatManager.Instance.SetPlayerCanAddition(isReticulisTime);
        reticulisWhiteCenter.SetActive(false);

        Destroy(reticule);        
    }
}