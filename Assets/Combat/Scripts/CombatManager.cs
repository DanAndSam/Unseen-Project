using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombatManager : MonoBehaviour
{
    public static CombatManager _instance;
    public static CombatManager Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = GameObject.FindObjectOfType<CombatManager>();

                if (_instance == null)
                {
                    GameObject container = new GameObject("CombatManager");
                    _instance = container.AddComponent<CombatManager>();
                }
            }
            return _instance;
        }
    }

   
    public AimingReticulis reticuleRef;
    public UserInterfaceManager uiRef;
    private PlayerController playerRef;

    public void InitCombat()
    {
        //Open Combat Interface
    }

    public void SuccessfulAddition()
    {
        uiRef.SuccessfulAddition();
    }

    public void SetPlayerReference(PlayerController player)
    {
        playerRef = player;
    }

    public void LaunchReticule()
    {                
        reticuleRef.Launch(playerRef.ReturnCurrentClipLength());
    }

    public bool ReturnIsReticulisTime()
    {
        return reticuleRef.isReticulisTime;
    }

    public void SetPlayerCanAddition(bool canAddition)
    {
        playerRef.canAddition = canAddition;
    }
}

