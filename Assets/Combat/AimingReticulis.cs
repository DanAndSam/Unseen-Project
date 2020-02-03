using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using DG.Tweening;
using UnityEngine;

public class AimingReticulis : MonoBehaviour
{
    public GameObject reticulis;
    public GameObject reticulisTarget;
    public float reticulisScaleFactor = 3;

    private int numberOfRiticuleRotations = 3;
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
        if(canLaunchRiticule)
            StartCoroutine(StartReticulis(reticuleTime));
    }

    public void SetReticuleSize(float size)
    {
        transform.localScale *= size;
    }

    public void ResetReticulis()
    {
        reticulis.transform.eulerAngles = reticulisStartRot;
        reticulis.transform.localScale = reticulisStartScale;
        reticulis.SetActive(false);
        reticulisTarget.SetActive(false);
        reticulis.GetComponent<Image>().color = reticulisStartColor;
        reticulisTarget.GetComponent<Image>().color = reticulisStartColor;
        canLaunchRiticule = true;
    }

    private IEnumerator StartReticulis(float reticuleTime)
    {
        canLaunchRiticule = false;
        reticulis.SetActive(true);
        reticulisTarget.SetActive(true);

        float rotationTime = reticuleTime / numberOfRiticuleRotations;

        reticulis.transform.DORotate(reticulisTarget.transform.eulerAngles, rotationTime).SetEase(Ease.Linear).SetLoops(numberOfRiticuleRotations, LoopType.Incremental);
        reticulis.transform.DOScale(reticulisTarget.transform.localScale, reticuleTime);

        yield return new WaitForSeconds(reticuleTime);
        
        ResetReticulis();
    }
}