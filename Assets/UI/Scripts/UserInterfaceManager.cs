using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class UserInterfaceManager : MonoBehaviour
{
    public GameObject forceLinePrefab;
    public Button attackButton;
    public Button reticuleButton;
    public Button nextAttack;
    public PlayerController playerRef;

    private GameObject tempForceLines;

    void Start()
    {
        reticuleButton.onClick.AddListener(() => CombatManager.Instance.LaunchReticule());
        attackButton.onClick.AddListener(() => playerRef.Attack());
    }

    public void SuccessfulAddition()
    {
        StartCoroutine(ForceLinesTimer());
    }

    private IEnumerator ForceLinesTimer()
    {
        tempForceLines = Instantiate(forceLinePrefab, transform.GetChild(0));
        yield return new WaitForSeconds(0.15f);
        Destroy(tempForceLines);
    }
}
